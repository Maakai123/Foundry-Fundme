
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity  ^0.8.18;

import { Script, console } from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

     function fundFundMe(address mostRecentlyDeployed) public {
       
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        console.log("Funded FundMe with %s", SEND_VALUE);

     }
    function run() external {
        
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe",
        block.chainid
        
        );
         vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed);
        //run function will call fundFundMe when ever it runs 
         vm.stopBroadcast();

    }
}

//How the above  works => It looks inside broadcast folder base on chain Id, and grabs the most deployed contract in that file 

contract  WithrawFundMe is Script {
    function withrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
         vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe",
        block.chainid
        );
       
        withrawFundMe(mostRecentlyDeployed);
        

    }
}


