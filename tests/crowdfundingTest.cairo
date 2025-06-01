use crowdfunding::crowdfunding::{ICrowdfundingDispatcherTrait, ICrowdfundingSafeDispatcher, ICrowdfundingSafeDispatcherTrait};
use super::common::{deploy_crowdfunding};
use super::constants::{ADDRESSES, ADDRESSESTrait};
use snforge_std::{
    CheatSpan,
    load, map_entry_address, cheat_caller_address,
    byte_array::try_deserialize_bytearray_error
};

#[test]
fn it_should_mark_the_caller_as_the_crowdfunding_manager() {
  let caller = ADDRESSES::CALLER.get();
  let minimum_contribution = 10;

  let (crowdfunding_dispatcher, _) = deploy_crowdfunding(caller, minimum_contribution);

  let manager = crowdfunding_dispatcher.get_manager();
  let minimum_contribution_in_contract = crowdfunding_dispatcher.get_minimum_contribution();

  assert_eq!(manager, caller);
  assert_eq!(minimum_contribution_in_contract, minimum_contribution);
  assert_ne!(minimum_contribution_in_contract, 20);
}

#[test]
fn it_should_allow_people_to_contribute_money_and_marks_them_as_approvers() {
  let caller = ADDRESSES::CALLER.get();
  let sponsor = ADDRESSES::SPONSOR.get();    
  let minimum_contribution = 10;
  let contribution = 15;

  let (crowdfunding_dispatcher, crowdfunding_address) = deploy_crowdfunding(caller, minimum_contribution);
  
  cheat_caller_address(crowdfunding_address, sponsor, CheatSpan::TargetCalls(1));
  crowdfunding_dispatcher.contribute(contribution);

  let is_approver = load(crowdfunding_address, map_entry_address(
    selector!("approvers"),
    array![sponsor.into()].span()
  ),1);

  assert_eq!(*is_approver.at(0), true.into());
}

#[test]
#[feature("safe_dispatcher")]
fn it_should_not_to_be_able_to_do_a_contribution_less_than_minimum() {
  let caller = ADDRESSES::CALLER.get();
  let sponsor = ADDRESSES::SPONSOR.get();
  let minimum_contribution = 10;
  let contribution = 9;  
  
  let (_, crowdfunding_address) = deploy_crowdfunding(caller, minimum_contribution);
  let crowdfunding_safe_dispatcher = ICrowdfundingSafeDispatcher { contract_address: crowdfunding_address };
  
  cheat_caller_address(crowdfunding_address, sponsor, CheatSpan::TargetCalls(1));
  match crowdfunding_safe_dispatcher.contribute(contribution) {
    Result::Ok(_) => panic!("This contribution shouldn't be allowed"),
    Result::Err(panic_data) => {
        let error_message = try_deserialize_bytearray_error(panic_data.span()).expect('wrong format');
        assert(error_message == "The contribution need to be greater than 10", 'Wrong message error received');
    }
  };
}

#[test]
fn it_should_be_able_to_manager_to_make_a_payment_request() {
  let caller = ADDRESSES::CALLER.get();
  let supplier = ADDRESSES::SUPPLIER.get();
  let request_description = "Test request";

  const request_value: usize = 5;
  const minimum_contribution: usize = 10;

  let (crowdfunding_dispatch, _) = deploy_crowdfunding(caller, minimum_contribution);

  let request_id = crowdfunding_dispatch.create_request(request_description.clone(), request_value, supplier);

  let created_request = crowdfunding_dispatch.get_request(request_id);

  assert_eq!(created_request.description, request_description);
  assert_eq!(created_request.value, request_value);
  assert_eq!(created_request.supplier, supplier);
}