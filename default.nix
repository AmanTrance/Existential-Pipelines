{ pkgs ? import <nixpkgs> { } } :
pkgs.mkShell {
  shellHook = ''
    docker build -t hs-static:latest .
    docker run --name=haskell-static -d hs-static:latest
    docker cp haskell-static:/existential .
    docker stop haskell-static
    docker rm haskell-static
    docker image rm hs-static:latest
  '';
}
