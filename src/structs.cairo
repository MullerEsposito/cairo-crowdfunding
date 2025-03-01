use starknet::{ContractAddress, Store};
use starknet::storage::{Vec};
use alexandria_storage::list::{List, ListTrait};

// #[derive(Drop, Serde, Store)]
// pub struct Summary {
//     pub minimumContribution: usize,
//     pub balance: usize,
//     pub numberOfRequests: u16,
//     pub numberOfApprovers: u16,
//     pub managerAddress: ContractAddress
// }

#[derive(Drop, Serde, starknet::Store)]
pub struct Request {
    pub description: ByteArray,
    pub value: usize,
    pub recipient: ContractAddress,
    pub isComplete: bool,
    pub yesVotes: usize
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