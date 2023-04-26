// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract lottery {
    // address payable public  manager;
    address payable public owner;
    mapping(address => uint256) public Users;

    address payable[] public participants;
    string public TNC;

    struct Lottery {
        address owner;
        string Lottery_name;
        uint256 date;
        uint256 Entry_price;
        uint256 Total_tickets;
        uint256 Ticket_remaining;
        uint256 commission;
    }
    uint256 minimalValue = 1;

    function PriceFeed() public payable {
        msg.value > minimalValue;
    }

    constructor() {
        owner = payable(msg.sender); //global variable;
    }

    modifier onlyOwner() {
        require((owner == msg.sender) || (Users[msg.sender] == 1));
        // require(Users[msg.sender]==1 ," error");
        _;
    }



    function createLottery(
        string memory Lottery_name,
        uint256 date,
        uint256 Entry_price,
        uint256 Total_tickets,
        uint256 commission
    ) external {
        require(date > block.timestamp, "You can create for future date");
        require(Total_tickets > 0, "There should be at least 1 ");
        //  owner = msg.sender();
        // manager = commission *
        //  Lottery_Number[nextId] = Lottery(msg.sender,Lottery_name,date,Entry_price,Total_tickets,Total_tickets,commission);
        //  nextId++;
    }

    receive() external payable {
        require(msg.value == 5 ether);

        participants.push(payable(msg.sender));
    }

    function addOwner(address _NewOwner, uint256 _i) public onlyOwner {
        // require(owner == msg.sender);
        Users[_NewOwner] = _i;
        // return owner;
    }

    function UserCheck(address check) public returns (uint256) {
        return Users[check];
    }

    function getblnce() public payable returns (uint256) {
        require(msg.sender == owner);
        require(msg.value < 0, " Lottery is End");
        return address(this).balance;
    }

    function random() public view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        participants.length
                    )
                )
            );
    }

    function selectwinner() public returns (address) {
        require(msg.sender == owner, "You're not the manager");
        require(
            participants.length >= 2,
            "There should be minimum 2 participants"
        );
        uint256 r = random();
        address payable winner;

        uint256 index = r % participants.length;
        winner = participants[index];
        // manager.transfer(getblnce()*5/10);
        owner.transfer((getblnce() * 5) / 10);
        winner.transfer(getblnce()); //winner will get the  total amount
        participants = new address payable[](0); //reset the lottery
        return winner;
    }

    function Terms_and_Condition(string memory TNC_) public returns (string memory)
    {   require(msg.sender==owner,"You are not the owner");
        return TNC = TNC_;
    }

    function GetLastestPrice() public view returns (uint256) {
        AggregatorV3Interface Price = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 price, , , ) = Price.latestRoundData();
        return uint256(price * 1e18);
    }

    

    function GetValueInDOllar(uint256 _ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ValuePrice = GetLastestPrice();
        uint256 AmountinDollars = (ValuePrice * _ethAmount) / 1e18;
        return AmountinDollars;
    }
}

