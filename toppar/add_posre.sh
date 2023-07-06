declare -a arr=('a' 'b' 'c' 'd' 'e')
for note in "${arr[@]}"
do
echo "; Include Position restraint file" >> PRO${note^^}.itp
echo "#ifdef POSRES_HEAVY" >> PRO${note^^}.itp
echo "#include \"restraints/posre_pro$note.itp\"" >> PRO${note^^}.itp
echo "#endif" >> PRO${note^^}.itp

echo "; Include Position restraint file" >> PRO${note^^}.itp
echo "#ifdef POSRES_BACKBONE" >> PRO${note^^}.itp
echo "#include \"restraints/posre_backbone_pro$note.itp\" " >> PRO${note^^}.itp
echo "#endif" >> PRO${note^^}.itp

echo "; Include Position restraint file" >> PRO${note^^}.itp
echo "#ifdef POSRES_CA" >> PRO${note^^}.itp
echo "#include \"restraints/posre_ca_pro$note.itp\" " >> PRO${note^^}.itp
echo "#endif" >> PRO${note^^}.itp

echo "; Include anchor restraint file" >> PRO${note^^}.itp
echo "#ifdef POSRES_ANCHOR" >> PRO${note^^}.itp
echo "#endif" >> PRO${note^^}.itp
done



