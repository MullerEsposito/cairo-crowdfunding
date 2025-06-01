use starknet::{ContractAddress, ClassHash};

#[starknet::interface]
pub trait ICrowdfundingFactory<TContractState> {
  fn create_crowdfunding(ref self: TContractState, manager: ContractAddress, minimum_contribute: usize) -> ContractAddress;
  fn update_crowdfunding_class_hash(ref self: TContractState, new_class_hash: ClassHash);
  fn get_crowdfunding_class_hash(ref self: TContractState) -> ClassHash;
  fn get_crowdfundings(ref self: TContractState) -> Array<ContractAddress>;
}

#[starknet::contract]
pub mod CrowdfundingFactory {
  use starknet::{ContractAddress, ClassHash, syscalls::deploy_syscall};
  use openzeppelin::utils::serde::SerializedAppend;
  use starknet::storage::{Vec, MutableVecTrait, StoragePointerReadAccess, StoragePointerWriteAccess};

  #[storage]
  struct Storage {
    crowdfunding_class_hash: ClassHash,
    crowdfundings: Vec<ContractAddress>,
  }

  #[constructor]
  fn constructor(ref self: ContractState, crowdfunding_class_hash: ClassHash) {
    self.crowdfunding_class_hash.write(crowdfunding_class_hash);
  }

  #[abi(embed_v0)]
  impl CrowdfundingFactory of super::ICrowdfundingFactory<ContractState> {
    fn create_crowdfunding(ref self: ContractState, manager: ContractAddress, minimum_contribute: usize) -> ContractAddress {
      let mut constructor_calldata: Array<felt252> = array![];
      constructor_calldata.append_serde(manager);
      constructor_calldata.append_serde(minimum_contribute);

      let (deployed_address, _) = deploy_syscall(
        self.crowdfunding_class_hash.read(),
        self.crowdfundings.len().into(),
        constructor_calldata.span(),
        false,
      ).unwrap();
      self.crowdfundings.append().write(deployed_address);

      deployed_address
    }

    fn update_crowdfunding_class_hash(ref self: ContractState, new_class_hash: ClassHash) {
      self.crowdfunding_class_hash.write(new_class_hash);
    }

    fn get_crowdfunding_class_hash(ref self: ContractState) -> ClassHash {
      self.crowdfunding_class_hash.read()
    }

    fn get_crowdfundings(ref self: ContractState) -> Array<ContractAddress> {      
      let mut crowdfundings = array![];

      for i in 0..self.crowdfundings.len() {
        crowdfundings.append(self.crowdfundings.at(i).read());
      };

      crowdfundings
    }
  }
}