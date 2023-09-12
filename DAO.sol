// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DAO {
    address public manager;
    uint public totalFunds;
    uint public proposalCount;

    struct Proposal {
        uint id;
        address creator;
        string description;
        uint amount;
        bool approved;
    }

    Proposal[] public proposals;

    constructor() {
        manager = msg.sender;
    }

    function createProposal(string memory description, uint amount) public {
        require(msg.sender == manager, "Only the manager can create proposals");
        uint proposalId = proposals.length;
        proposals.push(Proposal(proposalId, msg.sender, description, amount, false));
        proposalCount++;
    }

    function approveProposal(uint proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(msg.sender != proposal.creator, "Cannot approve your own proposal");
        require(msg.sender == manager, "Only the manager can approve proposals");
        require(!proposal.approved, "Proposal already approved");
        require(totalFunds >= proposal.amount, "Not enough funds in the DAO");

        proposal.approved = true;
        totalFunds -= proposal.amount;
    }

    function contribute() public payable {
        require(msg.value > 0, "Contribution must be greater than 0");
        totalFunds += msg.value;
    }

    function getProposalCount() public view returns (uint) {
        return proposalCount;
    }
}

