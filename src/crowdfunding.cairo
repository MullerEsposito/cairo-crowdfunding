use starknet::{ContractAddress, get_caller_address};
use crowdfunding::structs::{Request, RequestVoters, Summary};

#[starknet::interface]
pub trait ICrowdfunding<TContractState> {
  fn create_crowdfunding (ref self: TContractState, minimum: usize);
  fn contribute(ref self: TContractState, amount: usize);
  fn create_request(ref self: TContractState, description: ByteArray, value: usize, recipient: ContractAddress) -> usize;
  fn approve_request(ref self: TContractState, request_id: usize);
  fn finalize_request(ref self: TContractState, request_id: usize);
  fn get_request(self: @TContractState, request_id: usize) -> Request;
  fn get_request_voters(self: @TContractState, request_id: usize, address_voter: ContractAddress) -> bool;
  fn get_request_count(self: @TContractState) -> usize;
  fn get_summary(self: @TContractState) -> Summary;
  fn get_manager(self: @TContractState) -> ContractAddress;
  fn get_minimum_contribution(self: @TContractState) -> usize;
}

#[starknet::contract]
pub mod Crowdfunding {
  use starknet::storage::StoragePathEntry;
  use starknet::storage::Map;
  use super::{Request, RequestVoters, Summary, ContractAddress, get_caller_address};

  #[storage]
  struct Storage {
    manager: ContractAddress,
    minimum_contribution: usize,
    approvers: Map<ContractAddress, bool>,
    number_of_approvers: usize,
    requests: Map<usize, RequestVoters>,
    number_of_requests: usize,
  }

  #[constructor]
  fn constructor(ref self: ContractState, creator: ContractAddress, minimum: usize) {
    self.manager.write(creator);
    self.minimum_contribution.write(minimum);
  }
    
  #[abi(embed_v0)]
  impl Crowdfunding of super::ICrowdfunding<ContractState> {
    fn create_crowdfunding (ref self: ContractState, minimum: usize) {
      let caller = get_caller_address();
      self.manager.write(caller);
      self.minimum_contribution.write(minimum);
    }

    fn contribute(ref self: ContractState, amount: usize) {
      let minimum_contribution = self.minimum_contribution.read();
      assert!(amount > minimum_contribution, "The contribution need to be greater than {}", minimum_contribution);

      let caller = get_caller_address();
      self.approvers.write(caller, true);
    }

    fn create_request(ref self: ContractState, description: ByteArray, value: usize, recipient: ContractAddress) -> usize {
      let new_request = Request { description, value, recipient, is_complete: false, yes_votes: 0 };
      let request_id = self.number_of_requests.read() + 1;

      self.number_of_requests.write(request_id);
      self.requests.entry(request_id).request.write(new_request);

      request_id
    }

    fn get_request(self: @ContractState, request_id: usize) -> Request {
      let request = self.requests.entry(request_id).request.read();
      request
    }
      
    fn approve_request(ref self: ContractState, request_id: usize) {
      let caller = get_caller_address();
      let is_approver = self.approvers.entry(caller).read();
      assert!(is_approver, "Caller is not an approver");
      
      let mut request_voters = self.requests.entry(request_id);

      let is_not_already_voted = !request_voters.voters.entry(caller).read();
      assert!(is_not_already_voted, "Caller has already voted on this request");

      request_voters.voters.entry(caller).write(true);

      let current_yes_votes = request_voters.request.yes_votes.read();
      request_voters.request.yes_votes.write(current_yes_votes + 1);
    }

    fn finalize_request(ref self: ContractState, request_id: usize) {}

    fn get_request_voters(self: @ContractState, request_id: usize, address_voter: ContractAddress) -> bool {
      let request_voters = self.requests.entry(request_id);
      request_voters.voters.entry(address_voter).read()
    }

    fn get_request_count(self: @ContractState) -> usize {
      self.number_of_requests.read()
    }
      
    fn get_summary(self: @ContractState) -> Summary {
      let summary = Summary { 
        minimum_contribution: self.get_minimum_contribution(), 
        balance: 1, 
        number_of_requests: self.number_of_requests.read(), 
        number_of_approvers: self.number_of_approvers.read(),
        manager_address: self.get_manager(),
      };
      
      summary
    }

    fn get_manager(self: @ContractState) -> ContractAddress {
      self.manager.read()
    }

    fn get_minimum_contribution(self: @ContractState) -> usize {
      self.minimum_contribution.read()
    }
  }
}