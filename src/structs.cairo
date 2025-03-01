use starknet::{ContractAddress, storage::Vec};

#[derive(Drop, Serde, starknet::Store)]
pub struct Request {
    pub description: ByteArray,
    pub value: usize,
    pub recipient: ContractAddress,
    pub isComplete: bool,
    pub yesVotes: usize
}

#[derive(Drop, Serde, starknet::Store)]
pub struct Summary {
    pub minimumContribution: usize,
    pub balance: usize,
    pub numberOfRequests: u16,
    pub numberOfApprovers: u16,
    pub managerAddress: ContractAddress
}

#[starknet::storage_node]
pub struct RequestVoters {
    pub request: Request,
    pub voters: Vec<Voter>
}

#[derive(Drop, Serde, starknet::Store)]
struct Voter {
    address: ContractAddress,
    isVoted: bool
}