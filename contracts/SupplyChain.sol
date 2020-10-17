    /*
    This exercise has been updated to use Solidity version 0.6.12
    Breaking changes from 0.5 to 0.6 can be found here: 
    https://solidity.readthedocs.io/en/v0.6.12/060-breaking-changes.html
*/

pragma solidity ^0.6.12;

contract SimpleBank {

    //
    // State variables
    //

    /* Fill in the keyword. Hint: We want to protect our users balance from other contracts*/
  //  mapping (address => uint) balances;
    mapping(address => uint) balances;    

    /* Fill in the keyword. We want to create a getter function and allow contracts to be able to see if a user is enrolled.  */
    mapping (address => bool) public enrolled;

    /* Let's make sure everyone knows who owns the bank. Use the appropriate keyword for this*/
    address owner;

    //
    // Events - publicize actions to external listeners
    // ( I added dates to these events)
    
    /* Add an argument for this event, an accountAddress */
    event LogEnrolled(
//        uint256 date,
        address accountAddress
        );

    /* Add 2 arguments for this event, an accountAddress and an amount */
    event LogDepositMade(
  //      uint256 date,
        address accountAddress, 
        uint amount
        );

    /* Create an event called LogWithdrawal */
    /* Add 3 arguments for this event, an accountAddress, withdrawAmount and a newBalance */

    event LogWithdrawal(
        address accountAddress, 
        uint withdrawAmount,
        uint newBalance
        );


    //
    // Functions
    //

    /* Use the appropriate global variable to get the sender of the transaction */
    constructor() public {
        /* Set the owner to the creator of this contract */
        owner = address(this);
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    
    fallback() external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    // A SPECIAL KEYWORD prevents function from editing state variables;
    // allows function to run locally/off blockchain
    function getBalance() public view returns (uint) {
        /* Get the balance of the sender of this transaction */
        return balances[msg.sender];
    }
    function getEnrolledStatus() public view returns (bool) {
        /* Get the balance of the sender of this transaction */
        return enrolled[msg.sender];
    }



    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    // Emit the appropriate event
    function enroll() public returns (bool){
        enrolled[msg.sender] = true; 
        emit LogEnrolled( msg.sender);
        return enrolled[msg.sender];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    // Add the appropriate keyword so that this function can receive ether
    // Use the appropriate global variables to get the transaction sender and value
    // Emit the appropriate event    
    // Users should be enrolled before they can make deposits
    
    
    
    function deposit(uint _depositAmt) public returns (uint) {
        /* Add the amount to the user's balance, call the event associated with a deposit,
          then return the balance of the user */
        if (enrolled[msg.sender] == true) {
        balances[msg.sender] += _depositAmt;
        emit LogDepositMade( msg.sender, _depositAmt);
        }
        return(balances[msg.sender]);
    }
    


    // @notice Withdraw ether from bank
    // @dev This does not return any excess ether sent to it
    // @param withdrawAmount amount you want to withdraw
    // @return The balance remaining for the user
    // Emit the appropriate event    
    function withdraw(uint _withdrawAmount) public returns (uint) {
        /* If the sender's balance is at least the amount they want to withdraw,
           Subtract the amount from the sender's balance, and try to send that amount of ether
           to the user attempting to withdraw. 
           return the user's balance.*/
        require (enrolled[msg.sender] == true);

        // Check withdrawl amount 
        require(_withdrawAmount <= balances[msg.sender]);

        balances[msg.sender] -= _withdrawAmount;
        emit LogWithdrawal( msg.sender, _withdrawAmount, balances[msg.sender]);
        return(balances[msg.sender]);
    }

    
}
