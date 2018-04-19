(**
 * Name: Dir
 *
 * Responsible for reading the filenames of a given directory
 *)

(**
 * [dir_is_empty dir] is true, if [dir] contains no files except
 * "." and ".."
 *)
let dir_is_empty dir =
  Array.length (Sys.readdir dir) = 0

(**
 * [dir_contents] returns the paths of all regular files that are
 * contained in [dir]. Each file is a path starting with [dir].
 *)
let dir_contents dir =
  let rec loop result = function
    | f::fs when Sys.is_directory f ->
          Sys.readdir f
          |> Array.to_list
          |> List.map (Filename.concat f)
          |> List.append fs
          |> loop result
    | f::fs -> loop (f::result) fs
    | []    -> result
  in
    loop [] [dir]