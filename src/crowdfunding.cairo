use crowdfunding::structs::Summary;
use crowdfunding::structs::Request;
use starknet::{ContractAddress, get_caller_address};
use alexandria_storage::list::{List, ListTrait};

#[starknet::interface]
pub trait ICrowdfunding<TContractState> {
    fn contribute(ref self: TContractState, amount: usize);
    fn createRequest(ref self: TContractState, description: felt252, value: usize, recipient: ContractAddress);
    fn approveRequest(ref self: TContractState, index: usize);
    fn finalizeRequest(ref self: TContractState, index: usize);
    fn getRequestVoters(ref self: TContractState, indexRequest: usize, addressVoter: ContractAddress) -> bool;
    fn getRequestCount(ref self: TContractState) -> usize;
    // fn getSummary(ref self: TContractState) -> Summary;
    fn getManager(self: @TContractState) -> ContractAddress;
    fn getMinimumContribution(self: @TContractState) -> usize;
}

#[starknet::contract]
pub mod Crowdfunding {
    use super::Summary;
    use super::Request;
    use super::{ContractAddress, get_caller_address};
    use super::{List, ListTrait};

    #[storage]
    struct Storage {
        manager: ContractAddress,
        minimumContribution: usize,
        approvers: LegacyMap::<ContractAddress, bool>,
        numberOfApprovers: usize,
        // requests: List<Request>
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress, minimum: usize) {
        self.manager.write(owner);
        self.minimumContribution.write(minimum);
    }
    
    #[abi(embed_v0)]
    impl Crowdfunding of super::ICrowdfunding<ContractState> {
<<<<<<< HEAD
        fn contribute(ref self: ContractState, amount: usize) {}
=======
        fn contribute(ref self: ContractState, amount: usize) {
            let minimumContribution = self.minimumContribution.read();
            assert!(amount > minimumContribution, "The contribution need to be greater than {}", minimumContribution);

            let caller = get_caller_address();
            self.approvers.write(caller, true);
        }

>>>>>>> 6864bf0499b49160ef616bd6b4556e60f32d8643
        fn createRequest(ref self: ContractState, description: felt252, value: usize, recipient: ContractAddress) {}
        fn approveRequest(ref self: ContractState, index: usize) {}
        fn finalizeRequest(ref self: ContractState, index: usize) {}
        fn getRequestVoters(ref self: ContractState, indexRequest: usize, addressVoter: ContractAddress) -> bool {
            true
        }
        fn getRequestCount(ref self: ContractState) -> usize {
            1
        }
        // fn getSummary(ref self: ContractState) -> Summary {
        //     Summary { 
        //         minimumContribution: 1, 
        //         balance: 1, 
        //         numberOfRequests: 1, 
        //         numberOfApprovers: 1,
        //         managerAddress: "address"
        //     }
        // }
        fn getManager(self: @ContractState) -> ContractAddress {
            self.manager.read()
        }
        fn getMinimumContribution(self: @ContractState) -> usize {
            self.minimumContribution.read()
        }
    }
}