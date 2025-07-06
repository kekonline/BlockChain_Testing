// SPDX-License-Identifier: MIT

//pragma
pragma solidity ^0.8.8;


// imports
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

// errors
error FundMe__NotOwner();

// interfaces

//contracts

/**
 * @title FundMe
 * @author Kekonline
 * @notice  A contract for crowd funding
 * @dev This implements a price feed as our library
 */
contract FundMe {
// Type declarations
    using PriceConverter for uint256;

// State variables
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address public /* immutable */ i_owner;
    uint256 public constant MINIMUM_USD = 50 * 10 ** 18;
    AggregatorV3Interface public s_priceFeed;

// Modifiers
    modifier onlyOwner {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

// Functions
    // constructor
constructor(address priceFeedAddress) {
    s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    i_owner = msg.sender;
}

    // recieve and fallback functions
    // fallback() external payable {
    //     fund();
    // }

    // receive() external payable {
    //     fund();
    // }

/**
 * @notice Funds this contract
 * @dev This implements a price feed as our library
 * @dev We use the PriceConverter library to convert ETH to USD
 * @dev We use the require statement to ensure that the amount sent is greater than or equal to the minimum USD amount
 * @dev We use the addressToAmountFunded mapping to keep
 */
    function fund() public payable {
    require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
    
    function getVersion() public view returns (uint256){
        // ETH/USD price feed address of Sepolia Network.
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }
    
    function withdraw() public onlyOwner {
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }




}




