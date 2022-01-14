1. In this project we have created a FundMe contract.
2. In this we have learned about:-
    1. Creating a payable function and how to fund that contract.
    2. Further made a miniumum amount needed to enter the contract using the require function.
    3. Used the AggregatorV3Interface to get the price of ETH.
    4. Got the conversion rates using the getConversionRate function
    5. Created a withdraw function to withdraw the amount from the smartcontract in which we also created a onlyOwner modifier and reset all the funders msg.value to 0.