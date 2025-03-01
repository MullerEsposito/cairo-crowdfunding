use starknet::{ContractAddress, get_caller_address};
use crowdfunding::structs::{Request, RequestVoters, Summary};

#[starknet::interface]
pub trait ICrowdfunding<TContractState> {
    fn createCrowdfunding (ref self: TContractState, minimum: usize);
    fn contribute(ref self: TContractState, amount: usize);
    fn createRequest(ref self: TContractState, description: ByteArray, value: usize, recipient: ContractAddress) -> usize;
    fn approveRequest(ref self: TContractState, index: usize);
    fn finalizeRequest(ref self: TContractState, index: usize);
    fn getRequest(self: @TContractState, index: usize) -> Request;
    fn getRequestVoters(self: @TContractState, indexRequest: usize, addressVoter: ContractAddress) -> bool;
    fn getRequestCount(self: @TContractState) -> usize;
    fn getSummary(self: @TContractState) -> Summary;
    fn getManager(self: @TContractState) -> ContractAddress;
    fn getMinimumContribution(self: @TContractState) -> usize;
}

#[starknet::contract]
pub mod Crowdfunding {
    use starknet::storage::StoragePathEntry;
    use starknet::storage::Map;
    use super::{Request, RequestVoters, Summary, ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        manager: ContractAddress,
        minimumContribution: usize,
        approvers: Map::<ContractAddress, bool>,
        numberOfApprovers: usize,
        requests: Map::<usize, RequestVoters>,
        number_of_requests: usize,
    }

    #[constructor]
    fn constructor(ref self: ContractState, creator: ContractAddress, minimum: usize) {
        self.manager.write(creator);
        self.minimumContribution.write(minimum);
    }
    
    #[abi(embed_v0)]
    impl Crowdfunding of super::ICrowdfunding<ContractState> {
        fn createCrowdfunding (ref self: ContractState, minimum: usize) {
            let caller = get_caller_address();
            self.manager.write(caller);
            self.minimumContribution.write(minimum);
        }

        fn contribute(ref self: ContractState, amount: usize) {
            let minimumContribution = self.minimumContribution.read();
            assert!(amount > minimumContribution, "The contribution need to be greater than {}", minimumContribution);

            let caller = get_caller_address();
            self.approvers.write(caller, true);
        }

        fn createRequest(ref self: ContractState, description: ByteArray, value: usize, recipient: ContractAddress) -> usize {
            let new_request = Request { description, value, recipient, isComplete: false, yesVotes: 0 };
            let request_idx = self.number_of_requests.read() + 1;

            self.number_of_requests.write(request_idx);
            self.requests.entry(request_idx).request.write(new_request);

            request_idx
        }

        fn getRequest(self: @ContractState, index: usize) -> Request {
            let request = self.requests.entry(index).request.read();
            request
        }
        
        fn approveRequest(ref self: ContractState, index: usize) {}
        fn finalizeRequest(ref self: ContractState, index: usize) {}

        fn getRequestVoters(self: @ContractState, indexRequest: usize, addressVoter: ContractAddress) -> bool {
            true
        }

        fn getRequestCount(self: @ContractState) -> usize {
            1
        }
        
        fn getSummary(self: @ContractState) -> Summary {
            let summary = Summary { 
                minimumContribution: 1, 
                balance: 1, 
                numberOfRequests: 1, 
                numberOfApprovers: 1,
                managerAddress: self.getManager(),
            };
            
            summary
        }
        
        fn getManager(self: @ContractState) -> ContractAddress {
            self.manager.read()
        }
        fn getMinimumContribution(self: @ContractState) -> usize {
            self.minimumContribution.read()
        }
    }
}