use crowdfunding::structs::Summary;
use crowdfunding::structs::Request;
use starknet::ContractAddress;

#[starknet::interface]
trait ICrowdfunding<TContractState> {
    fn contribute(ref self: TContractState);
    fn createRequest(ref self: TContractState, description: felt252, value: usize, recipient: ByteArray);
    fn approveRequest(ref self: TContractState, index: usize);
    fn finalizeRequest(ref self: TContractState, index: usize);
    fn getRequestVoters(ref self: TContractState, indexRequest: usize, addressVoter: ByteArray) -> bool;
    fn getRequestCount(ref self: TContractState) -> usize;
    fn getSummary(ref self: TContractState) -> Summary;
}

#[starknet::contract]
mod Crowdfunding {
    use super::Summary;
    use super::Request;
    use super::ContractAddress;

    #[storage]
    struct Storage {
        manager: ContractAddress,
        minimumContribution: usize,
        approvers: Felt252Dict<bool>,
        numberOfApprovers: usize,
        requests: Array<Request>
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress, minimum: usize) {
        self.manager.write(owner);
        self.minimumContribution.write(minimum);
    }
    
    #[abi(embed_v0)]
    impl Crowdfunding of super::ICrowdfunding<ContractState> {
        fn contribute(ref self: ContractState) {}
        fn createRequest(ref self: ContractState, description: felt252, value: usize, recipient: ByteArray) {}
        fn approveRequest(ref self: ContractState, index: usize) {}
        fn finalizeRequest(ref self: ContractState, index: usize) {}
        fn getRequestVoters(ref self: ContractState, indexRequest: usize, addressVoter: ByteArray) -> bool {
            true
        }
        fn getRequestCount(ref self: ContractState) -> usize {
            1
        }
        fn getSummary(ref self: ContractState) -> Summary {
            Summary { 
                minimumContribution: 1, 
                balance: 1, 
                numberOfRequests: 1, 
                numberOfApprovers: 1,
                managerAddress: "address"
            }
        }
    }
}
