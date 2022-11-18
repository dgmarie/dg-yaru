mapfile -t array < <(diff --report-identical-files --recursive gnome-43 gnome-42 | grep 'are identical')

for i in "${array[@]}"; do
  file1="$(echo "${i}" | cut -d ' ' -f 2)"
  file2="$(echo "${i}" | cut -d ' ' -f 4)"
  ln -rsf $file1 $file2
done
