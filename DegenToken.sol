// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function mint(address to, uint256 amount) external;
    function burn(uint256 amount) external;
    function addItem(uint256 Item, string memory itemName) external;
    function redeemItem(uint256 Item) external payable;
    function ItemInfo(uint256 Item) external view returns (string memory);
    function owner() external view returns (address);
}

contract DegenToken is IERC20 {
    string public name;
    string public symbol;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(uint256 => string) private _items;
    address private _owner;

    event ItemRedeemed(address indexed player, uint256 Item);

    constructor() {
        name = "Degen";
        symbol = "DGN";
        _totalSupply = 0;
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only the owner can call this function");
        _;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        require(amount > 0, "Amount must be greater than zero.");
        require(_balances[msg.sender] >= amount, "Insufficient balance.");

        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;

        return true;
    }

    function mint(address to, uint256 amount) external override onlyOwner {
        require(amount > 0, "Amount must be greater than zero.");

        _totalSupply += amount;
        _balances[to] += amount;
    }

    function burn(uint256 amount) external override {
        require(amount > 0, "Amount must be greater than zero.");
        require(_balances[msg.sender] >= amount, "Insufficient balance.");

        _totalSupply -= amount;
        _balances[msg.sender] -= amount;
    }

    function addItem(uint256 Item, string memory itemName) external override {
        require(bytes(_items[Item]).length == 0, "Item already exists");

        _items[Item] = itemName;
    }

    function redeemItem(uint256 Item) external override payable {
        require(bytes(_items[Item]).length > 0, "Item does not exist");
        require(_balances[msg.sender] >= 50, "Insufficient balance");

        _balances[msg.sender] -= 50;
        emit ItemRedeemed(msg.sender, Item);
        
    }

    function ItemInfo(uint256 Item) external view override returns (string memory) {
        return _items[Item];
    }

    function owner() external view override returns (address) {
        return _owner;
    }
}
