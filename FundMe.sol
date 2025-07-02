// SPDX-License-Identifier: MIT

pragma solidity 0.8.30;

contract FundMe {
    uint public minimumusd = 50;

    function fund() public payable {
        require(msg.value > 1e18, "Didn't send enough");
    }

    //function withdraw(){}
}
