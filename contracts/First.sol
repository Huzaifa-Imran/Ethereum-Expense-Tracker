pragma solidity >0.5.0 <= 0.6.0;

contract First {

    struct Transaction {
        uint amount;
        uint date;
        address owner;
        string title;
        string types;
        string client;
    }
    mapping(address => uint) ownerTotalTransactions;
    Transaction[] transactions;

    function addTransaction(uint _amount, string memory _client, string memory _title, string memory _types) public {
        transactions.push(Transaction(_amount, block.timestamp, msg.sender, _title, _types, _client));
        ownerTotalTransactions[msg.sender]++;
    }

    modifier onlyOwnerOf(uint _transId) {
        require(msg.sender == transactions[_transId].owner);
        _;
    }

    function viewAllTransactions() external view returns(uint[] memory) {
        
        uint[] memory result = new uint[](ownerTotalTransactions[msg.sender]);
        uint counter = 0;
        for(uint i = 0; i < transactions.length; i++) {
            if(transactions[i].owner == msg.sender) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function getTransactionDetails(uint _transId) public view onlyOwnerOf(_transId) returns(string memory, uint, uint, string memory, string memory) {
        Transaction memory t = transactions[_transId];
        return (t.client, t.amount, t.date, t.title, t.types);
    }
}