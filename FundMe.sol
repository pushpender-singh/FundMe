// SPDX-License-Identifier:MIT

pragma solidity >=0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";


contract FundMe{

    using SafeMathChainlink for uint256;

    mapping(address=> uint256) public addressToAmountFunded;
    address public owner;
    address[] public funders;

    constructor() public {
        owner= msg.sender;
    }
    function fund() public payable{
        uint256 minimumUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value)>=minimumUSD, "Need to spend more ETH");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
    function getVersion() public view returns(uint256){
        return AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e).version();
    }
    function price() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,)=priceFeed.latestRoundData();
        return uint256(answer*10000000000); //It has now 18 decimal. It is not necessary moreover it will take extra gas.
    }
    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice= price();
        uint256 ethAmountInUSD = (ethPrice*ethAmount)/ 1000000000000000000;
        return ethAmountInUSD;
    }
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    function withdraw() payable onlyOwner public{
        msg.sender.transfer(address(this).balance);
        for(uint256 funderIndex=0; funderIndex < funders.length; funderIndex++) {
        address funder = funders[funderIndex];
        addressToAmountFunded[funder]= 0;
        }
        funders = new address[](0);
    }
}