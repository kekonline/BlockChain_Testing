// SPDX-License-Identifier: MIT

pragma solidity 0.8.30;

import "./PriceConverter.sol";

// constant and immutable use less gas

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    uint public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint) public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(
            (msg.value.getConversionRate()) >= MINIMUM_USD,
            "Didn't send enough money"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (
            uint funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        //         //transfer
        //         funders = new address[](0);
        //         payable(msg.sender).transfer(address(this).balance);

        // //send
        //     bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //     require(sendSuccess,"Failed to send Ether");

        // // call
        // (bool callSuccess, )=payable(msg.sender).call{value: address(this).balance}("");
        //  require(callSuccess,"Failed to send Ether");

        // --- Using transfer ---
        // Automatically reverts on failure
        // Forwards exactly 2300 gas – enough to log an event but not enough to call complex fallback functions
        // Safer in older Solidity versions but not recommended now due to increased gas costs in EVM
        funders = new address[](0);
        payable(msg.sender).transfer(address(this).balance);

        // --- Using send ---
        // Returns a boolean indicating success or failure (must manually check with require)
        // Also forwards only 2300 gas
        // Considered safer than transfer in some edge cases, but still limited
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Failed to send Ether");

        // --- Using call ---
        // Most flexible and recommended way in modern Solidity
        // Forwards all available gas by default (can customize)
        // Returns a tuple: (bool success, bytes memory data)
        // Can call functions, not just send Ether
        // Must check for success and guard against reentrancy attacks
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Failed to send Ether");
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Only the owner can withdraw");
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }
}
