{ pkgs, lib }:
let

in
{
  submitTest = submitTest;
  submitTests = submitTests;
  gotoTest = gotoTest;
  gotoTests = gotoTests;
  pkgs = {
    netero-test = netero-test;
    default = netero-test;
  };
}
 

