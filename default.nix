{ pkgs, lib }:
let

in
{
  submitTest = submitTest;
  submitTests = submitTests;
  gotoTest = gotoTest;
  gotoTests = gotoTests;
  pkgs = {
    posix-browser = posix-browser;
    default = posix-browser;
  };
}
 

