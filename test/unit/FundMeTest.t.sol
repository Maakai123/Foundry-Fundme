 
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import { Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

//fumMe test to inherit test
contract FundMeTest is Test {

    //variable so it wont over ride 
    FundMe fundMe; //scoped the whole fundction will get accessed to it

    //we want the address to always be the address deploying the contract  //(makeAddr(string memory name))

    address USER = makeAddr("user");
 uint256 constant SEND_VALUE = 0.1 ether; //1000000000000000000
 //must give a user a starting balance 

 uint256 constant STARTING_BALANCE = 10 ether;
 
 function setUp( ) external {
    //use variable fundMe to create new contract

    // us -> FundMeTest--> FundMe
     //us calling FundMeTest  which deploys FundMe, owner of FundMe is FundMeTest
   // fundMe = new FundMe( 0x694AA1769357215DE4FAC081bf1f309aDC325306);
   DeployFundMe deployFundMe = new DeployFundMe();
   fundMe = deployFundMe.run();
   vm.deal(USER, STARTING_BALANCE);

 }

 function testMinimumDollarIsFive() public view {
    //ensure that minimum_usd must be 5e18
    //assertEq is coming from Test
   assertEq(fundMe.MINIMUM_USD(),5e18); //minim = 5e18
 }

 function testOwnerIsMsgSender()  public  view {
    console.log(fundMe.getOwner());
    console.log(msg.sender);
    //this wont work, i_owner is different from msg.sender address
   // assertEq(fundMe.i_owner(), msg.sender); failed b/c i_owner != msg.sender; 
    //assertEq(fundMe.i_owner(), address(this)); // i_owner  must  = msg.msg.sender
    assertEq(fundMe.getOwner(), msg.sender); // after refactoring this now works
    
 }

/*
Types of Test 
Unit 
-Testing a specific part of our code

2.Integration
- Testing how our code works with other parts of our code 

3. Forked
  -Testing our code on a simulated real environment

  4. Staging
  -Testing our code in a real environment that is not prod

 */

function testPriceFeedVersionIsAccurate() public view {
     uint256 version = fundMe.getVersion();
     assertEq(version, 4);
}
 

 function testFundFailWithoutEnoughETH() public {
   vm.expectRevert(); //Hey the line should revert
   // assert(Thus tx fails/revert)
   fundMe.fund(); // send 0 value
 }


 function testFundUpdatesFundedDataStructure() public {
   // prank is a testcheat sheet
   vm.startPrank(USER); // the next Tx will be sent by User
   fundMe.fund{ value: SEND_VALUE}();
   vm.stopPrank();
   uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
   assertEq(amountFunded, SEND_VALUE);

}

function testAddsFunderToArrayOfFunders() public {
   vm.startPrank(USER);
   fundMe.fund{value: SEND_VALUE}();
    vm.stopPrank();

   address funder = fundMe.getFunder(0); //ndex 0 =.  user
   assertEq(funder, USER);
}

//best prctice
modifier funded() {
   vm.prank(USER);
   fundMe.fund{value: SEND_VALUE}();
   _;
}


function testOnlyOwnerCanWithdraw() public funded {
   //fundMe.fund{value:SEND_VALUE}(); // coming from modifier
   //make sure only owner can withdraw
   vm.expectRevert(); //failor revert if user != addres wner
   vm.prank(USER); //owner address = User
   fundMe.withdraw();
}

function testWithDrawWithASingleFunder() public funded {
   //Arrange 
   uint256 startingOwnerBalance = fundMe.getOwner().balance; //balance of get owner func
   uint256 startingFundMeBalance = address(fundMe).balance;


   //Act
   vm.startPrank(fundMe.getOwner());
   fundMe.withdraw();   ////only owner will withdraw
   vm.stopPrank();
  //assert

  uint256 endingOwnerBalance = fundMe.getOwner().balance;
  uint256 endingFundMeBalance = address(fundMe).balance;
  assertEq(endingFundMeBalance, 0); // equal 0;
  assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);

}

 //numbers interms of creating  addresses is uint160
   function testWithdrawFromMultipleFunders() public funded {
      //Arrange 
      uint160 numberOfFunders = 10;
      uint160 startingFunderIndex = 2;

      for(uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
         //vm.prank new address
         //vm.deal new address
         //address()
         //cheat sheet for all the above
         
         //Address pf different people
         hoax(address(i), STARTING_BALANCE);
         fundMe.fund{value: SEND_VALUE}();

      }

       uint256 startingOwnerBalance = fundMe.getOwner().balance; //balance of get owner func
       uint256 startingFundMeBalance = address(fundMe).balance;

       // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();
        //Asset 
      assert(address(fundMe).balance == 0);
      assert( startingFundMeBalance + startingOwnerBalance ==
         fundMe.getOwner().balance
      );
   }
    
  

}
//Note anytime a test is ran, its runs setup before exercuting the code


//require(msg.value.getConversionRate() >= MINIMUM_USD,
  
