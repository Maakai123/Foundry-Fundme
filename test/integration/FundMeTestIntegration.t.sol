// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import { Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundFundMe, WithrawFundMe } from "../../script/Interactions.s.sol" ;
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract InteractionTest is Test {
 FundMe fundMe;
  address USER = makeAddr("user");
 uint256 constant SEND_VALUE = 0.1 ether; //1000000000000000000
 //must give a user a starting balance 

 uint256 constant STARTING_BALANCE = 10 ether;
 uint256 constant GAS_PRICE = 1;

 function setUp() external {
    DeployFundMe deploy = new DeployFundMe();
    fundMe = deploy.run();
    vm.deal(USER, STARTING_BALANCE);
 }

 function testUserCanFundInteractions() public {
    vm.prank(USER);
    fundMe.fund{value: SEND_VALUE}();
    
   WithrawFundMe withdrawFundMe = new WithrawFundMe();
  withdrawFundMe.withrawFundMe(address(fundMe));

  assert(address(fundMe).balance == 0);



 }
       
}
  