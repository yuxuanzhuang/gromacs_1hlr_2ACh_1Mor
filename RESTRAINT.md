# Run simulations with restraints

The purpose of running equilibration with restraints is to allow the system to relax to a more stable conformation while preventing the ligand from escaping the binding pocket. This is achieved by applying harmonic restraints to the ligand and C-alpha atoms of the protein while allowing the rest of the system to move freely. The water molecules for example might move into some cavities in the protein and stabilize the protein-ligand complex. To apply restraints, two kinds files are required to be modified: topology file,e.g. .itp file, and mdp file.

## Running equilibrations run with restraints

First let's have a look at the mdp file in the command below
    
```bash
gmx grompp -f mdp/ca.mdp -o ca.tpr -c em.gro -r em.gro -p topol.top -maxwarn 2
```

In `mdp/ca.mdp` the following line `define = -DPOSRES_HET -DPOSRES_CA` will define two flags `POSRES_HET` and `POSRES_CA` so later when GROMACS tries to read the topology file, it will recognize these flags and apply the restraints to the ligand and C-alpha atoms of the protein.

In `toppar/ACHO.itp` file exists a block
```bash
#ifdef POSRES_HET
[ position_restraints ]
   1   1   1000  1000  1000
   19   1   1000  1000  1000
```
meaning when `-DPOSRES_HET` flag is defined, the restraints will be applied to the atoms 1 and 19 of the ligand with a force constant of 1000 kJ/mol/nm^2 for each direction. (read more https://manual.gromacs.org/current/reference-manual/functions/restraints.html)

## How to generate the restraints file
You can either manually add these lines to the topology file, e.g. for ligand or use `toppar/restraints/restrains.sh` script to generate the restraints file of protein. Inside the script, note the index of the restraints are not the index for the whole system but only for the specific molecule/protein. So we need to first filter each chain (that are recognize as a single molecule in GROMACS) with `gmx select -f ../../start.pdb -s ../../start.pdb -ofpdb pro$index.pdb -pdbatoms selected` and then use `gmx genrestr -f pro$index.pdb -o posre_pro$index.itp` to select the part we want to restraint and generate the restraints file.

## Running production run with restraints
In the production `md.mdp` file, we defined `-DPOSRES_ANCHOR` that will apply restraints to the anchor atoms of the protein. This way, most atoms of the protein is not rigid but just "anchored" to the same place by the restraint. The anchor atoms are defined to be the C-alpha of the last residue in each chain of the protein in this case; check `toppar/PROA.itp` as an example. You can extract the index of this atom from `[ atoms ]` block in the same file and add this restraint to the topology file manually.

```bash
; Include anchor restraint file
#ifdef POSRES_ANCHOR
[ position_restraints ]
 3486   1   1000 1000 1000
#endif
```