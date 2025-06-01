use openzeppelin::utils::serde::SerializedAppend;
use crowdfunding::crowdfunding::{ICrowdfundingDispatcher};
use crowdfunding::crowdfundingFactory::{ICrowdfundingFactoryDispatcher};
use starknet::{ContractAddress, ClassHash};
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};


pub fn declare_crowdfunding_contract() -> ClassHash {
  let contract_class = declare("Crowdfunding").unwrap().contract_class();
  *contract_class.class_hash
}

pub fn deploy_crowdfunding(manager: ContractAddress, minimumContribution: usize) -> (ICrowdfundingDispatcher, ContractAddress) {
    let crowdfunding_contract_class = declare("Crowdfunding").unwrap().contract_class();

    let mut constructor_calldata: Array<felt252> = array![];
    constructor_calldata.append_serde(manager);
    constructor_calldata.append_serde(minimumContribution);

    let (crowdfunding_contract_address, _) = crowdfunding_contract_class.deploy(@constructor_calldata).unwrap();
    let crowdfunding_dispatcher = ICrowdfundingDispatcher { contract_address: crowdfunding_contract_address };
    
    (crowdfunding_dispatcher, crowdfunding_contract_address)
}

pub fn deploy_crowdfunding_factory(crowdfunding_class_hash: ClassHash) -> (ICrowdfundingFactoryDispatcher, ContractAddress) {
  let contract_class = declare("CrowdfundingFactory").unwrap().contract_class();

    let mut constructor_calldata: Array<felt252> = array![];
    constructor_calldata.append_serde(crowdfunding_class_hash);

    let (crowdfunding_factory_address, _) = contract_class.deploy(@constructor_calldata).unwrap();
    let crowdfunding_factory_dispatcher = ICrowdfundingFactoryDispatcher { contract_address: crowdfunding_factory_address };
    
    (crowdfunding_factory_dispatcher, crowdfunding_factory_address)
}

pub fn get_crowdfunding_dispatcher(crowdfunding_address: ContractAddress) -> ICrowdfundingDispatcher {
    ICrowdfundingDispatcher { contract_address: crowdfunding_address }
}

