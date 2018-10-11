pragma solidity ^0.4.0;

contract Fungi {
    
    struct Point {
	uint x;
	uint y;
    }

    struct Connection {
	address alice;
	address bob;
    }

    struct Request {
	address requested;
	address requestee;
    }

    mapping(address => Point) points;
    mapping(bytes32 => Connection) connections;
    mapping(bytes32 => Request) requests;

    event NewConnection(address alice, address bob);

    function newPoint() public {
	Point memory p = Point(42, 42);
	points[msg.sender] = p;
    }

    function getPoint(address account) public view returns (uint, uint) {
	Point storage p = points[account];
	return (p.x, p.y);
    }

    function toLinkAddress(address account0, address account1) public pure returns (bytes32) {
	if(uint(account0) <= uint(account1)) {
	    return keccak256(abi.encodePacked(keccak256(abi.encodePacked(account0)), keccak256(abi.encodePacked(account1))));
	} else {
	    return keccak256(abi.encodePacked(keccak256(abi.encodePacked(account1)), keccak256(abi.encodePacked(account0))));
	}
    }    

    function newConnectionRequest(address account) public {
	Request memory r = Request(account, msg.sender);
	bytes32 link = toLinkAddress(account, msg.sender);
	requests[link] = r;
    }

    function approveConnectionRequest(bytes32 linkAddress) public {
	Request storage r = requests[linkAddress];
	
	require(r.requested == msg.sender);
	
	Connection memory c = Connection(r.requested, r.requestee);
	connections[linkAddress] = c;
	
	emit NewConnection(r.requested, r.requestee);
    }

    function getConnection(bytes32 linkAddress) public view returns (address, address) {
	Connection storage c = connections[linkAddress];
	return (c.alice, c.bob);
    }
}
