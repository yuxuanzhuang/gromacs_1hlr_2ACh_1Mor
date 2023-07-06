declare -a arr=('a' 'b' 'c' 'd' 'e')
for index in "${arr[@]}"
do
gmx select -f ../../start.pdb -s ../../start.pdb -ofpdb pro$index.pdb -pdbatoms selected<<EOF
chain ${index^^}
EOF
gmx genrestr -f pro$index.pdb -o posre_pro$index.itp<<EOF
2
EOF
gmx genrestr -f pro$index.pdb -o posre_backbone_pro$index.itp<<EOF
4
EOF
gmx genrestr -f pro$index.pdb -o posre_ca_pro$index.itp<<EOF
3
EOF
done
