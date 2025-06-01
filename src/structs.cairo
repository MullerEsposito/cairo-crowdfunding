use starknet::{ContractAddress, storage::Map};

#[derive(Drop, Serde, starknet::Store)]
pub struct Request {
  pub description: ByteArray,
  pub value: usize,
  pub supplier: ContractAddress,
  pub is_complete: bool,
  pub yes_votes: usize
}

#[derive(Drop, Serde, starknet::Store)]
pub struct Summary {
  pub minimum_contribution: usize,
  pub balance: usize,
  pub number_of_requests: usize,
  pub number_of_approvers: usize,
  pub manager_address: ContractAddress
}

#[starknet::storage_node]
pub struct RequestVoters {
  pub request: Request,
  pub voters: Map<ContractAddress, bool>
}