# Repositories and versions to use

## skywater-pdk:

Please stick to version `v0.0.0-303-g3d7617a`
(commit hash: `3d7617a1acb92ea883539bcf22a632d6361a5de4`)
```
git clone https://github.com/google/skywater-pdk.git
cd skywater-pdk
git checkout v0.0.0-303-g3d7617a
git submodule update --init libraries/sky130_fd_sc_hd/latest
git submodule update --init libraries/sky130_fd_sc_hvl/latest
...
git submodule update --init libraries/sky130_fd_io/latest
```

## open_pdks:

Please stick to the `mpw-one-a` tag.
```
git clone https://github.com/RTimothyEdwards/open_pdks.git -b mpw-one-a
```

## OpenLane:

Please stick to the `mpw-one-a` tag.
```
git clone https://github.com/efabless/openlane.git -b mpw-one-a
```
Note that the `mpw-one-a` tag is equivalent to the `rc5` tag. Also, note that
running `make` inside the openlane directory will automatically grab the right
versions of `open_pdks` and `skywater-pdk` as listed above and install them to
PDK_ROOT.

For example,

```
export PDK_ROOT=$HOME/pdks
cd openlane
make
```

## Caravel: 

Please stick to the `mpw-one-a` tag.
```
git clone https://github.com/efabless/caravel.git -b mpw-one-a
```

## Notes

- If you have already successfully hardened your blocks and have a clean
  `user_project_wrapper`, you don't have to recreate it and can just reuse it.
  No changes have been made to the user project area or to the tools that
  require you to reharden your design(s).

- If you prefer to re-generate your blocks (using OpenLane), you can refer to
  this [page][1].

- **IMPORTANT**. Do not forget to run `make uncompress -j4` in the caravel root
  directory before you start working. Likewise, before you commit and push your
  changes back, run `make compress -j4`.

- If you already have a clean working tree in a previously cloned repository from
  those listed above, what you need to do is:
  ```
  git pull
  git checkout tag
  ```

[1]: ./openlane/README.md
