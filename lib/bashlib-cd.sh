# @name bashlib-cd
# @brief A library of cd functions
# @description
#     A library of cd functions kept for historical purpose
#
#     Check instead:
#     * [zoxide](https://github.com/ajeetdsouza/zoxide)
#     * and the `Alt+C` binding of [fzf](https://github.com/junegunn/fzf#key-bindings-for-command-line)
#
#


# @description
#    This function defines a 'cd' replacement function capable of keeping,
#    displaying and accessing history of visited directories, up to 10 entries.
#    Type in `cd --` to get a recent list of directories.
#    acd_func 1.0.5, 10-nov-2004
#    Petar Marinov, http:/geocities.com/h2428, this is public domain
# @arg $1 string a path
cd::cd()
 {
   local x2 the_new_dir adir index
   local -i cnt

   if [[ $1 ==  "--" ]]; then
     dirs -v
     return 0
   fi

   the_new_dir=$1
   [[ -z $1 ]] && the_new_dir=$HOME

   if [[ ${the_new_dir:0:1} == '-' ]]; then
     #
     # Extract dir N from dirs
     index=${the_new_dir:1}
     [[ -z $index ]] && index=1
     adir=$(dirs +$index)
     if [[ -z "$adir" ]]; then
         if [[ "$SHELL" == "/bin/zsh" ]]; then
             cd ~${index}
             return 0
             else
                echo "ADIR is null. Terminating." && return 1
         fi
     fi
     the_new_dir=$adir
   fi

   #
   # '~' has to be substituted by ${HOME}
   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

   #
   # Now change to the new dir and add to the top of the stack
   pushd "${the_new_dir}" > /dev/null || return 1
   the_new_dir=$(pwd)

   # Trim down everything beyond 11th entry
   popd -n +11 2>/dev/null 1>/dev/null

   #
   # Remove any other occurrence of this dir, skipping the top of the stack
   for ((cnt=1; cnt <= 10; cnt++)); do
     x2=$(dirs +${cnt} 2>/dev/null) || return 0
     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
     if [[ "${x2}" == "${the_new_dir}" ]]; then
       popd -n +$cnt 2>/dev/null 1>/dev/null
       cnt=$((cnt-1))
     fi
   done

   return 0
 }