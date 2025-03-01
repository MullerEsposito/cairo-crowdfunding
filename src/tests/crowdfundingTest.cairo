use crowdfunding::crowdfunding::{ICrowdfundingDispatcherTrait, ICrowdfundingSafeDispatcher, ICrowdfundingSafeDispatcherTrait};
use super::common::{deployCrowdfundingContract};
use starknet::{ContractAddress, contract_address_const};
use snforge_std::{
    CheatSpan,
    load, map_entry_address, cheat_caller_address,
    byte_array::try_deserialize_bytearray_error
};

#[test]
fn it_should_mark_the_caller_as_the_crowdfunding_manager() {
    let caller = contract_address_const::<'caller'>();
    let minimumContribution: usize = 10;

    let (_, crowdfundingAddress) = deployCrowdfundingContract(caller, minimumContribution);

    let manager = load(crowdfundingAddress, selector!("manager"), 1);
    let minimumContributionInContract = load(crowdfundingAddress, selector!("minimumContribution"), 1);

    assert_eq!(*manager.at(0), caller.into());
    assert_eq!(*minimumContributionInContract.at(0), minimumContribution.into());
    assert_ne!(*minimumContributionInContract.at(0), 20);
}

#[test]
fn it_should_allow_people_to_contribute_money_and_marks_them_as_approvers() {
    let manager = contract_address_const::<'manager'>();
    let approver = contract_address_const::<'approver'>();
    
    
    let minimumContribution: usize = 10;
    let contribution: usize = 15;
    let (crowdfunding_dispatcher, crowdfunding_address) = deployCrowdfundingContract(manager, minimumContribution);
    
    cheat_caller_address(crowdfunding_address, approver, CheatSpan::TargetCalls(1));
    crowdfunding_dispatcher.contribute(contribution);

    let isApprover = load(crowdfunding_address, map_entry_address(
        selector!("approvers"),
        array![approver.into()].span()
    ),1);

    assert_eq!(*isApprover.at(0), true.into());
}

#[test]
#[feature("safe_dispatcher")]
fn it_should_not_to_be_able_to_do_a_contribution_less_than_minimum() {
    let manager = contract_address_const::<'manager'>();
    let approver = contract_address_const::<'approver'>();
    
    
    let minimum_contribution: usize = 10;
    let contribution: usize = 9;
    let (_, crowdfunding_address) = deployCrowdfundingContract(manager, minimum_contribution);
    let crowdfunding_safe_dispatcher = ICrowdfundingSafeDispatcher { contract_address: crowdfunding_address };
    
    cheat_caller_address(crowdfunding_address, approver, CheatSpan::TargetCalls(1));
    match crowdfunding_safe_dispatcher.contribute(contribution) {
        Result::Ok(_) => panic!("This contribution shouldn't be allowed"),
        Result::Err(panic_data) => {
            let _error_message = try_deserialize_bytearray_error(panic_data.span()).expect('wrong format');
            assert(_error_message == "The contribution need to be greater than 10", 'Wrong message error received');
        }
    };
}

#[test]
fn it_should_be_able_to_manager_to_make_a_payment_request() {
    let caller: ContractAddress = contract_address_const::<'caller'>();
    let recipient: ContractAddress = contract_address_const::<'recipiente'>();
    let request_description: ByteArray = "Test request";
    const requestValue: usize = 5;
    const minimumContribution: usize = 10;

    let (crowdfunding_dispatch, _) = deployCrowdfundingContract(caller, minimumContribution);

    let request_id = crowdfunding_dispatch.createRequest(request_description.clone(), requestValue, recipient);

    let created_request = crowdfunding_dispatch.getRequest(request_id);

    assert_eq!(created_request.description, request_description);
    assert_eq!(created_request.value, requestValue);
    assert_eq!(created_request.recipient, recipient);
}