use super::constants::{ADDRESSES, ADDRESSESTrait};
use super::common::{declare_crowdfunding_contract, deploy_crowdfunding_factory, get_crowdfunding_dispatcher};
use crowdfunding::crowdfundingFactory::{ICrowdfundingFactoryDispatcherTrait};
use crowdfunding::crowdfunding::{ICrowdfundingDispatcherTrait};

#[test]
fn it_should_deploy_crowdfunding_factory() {
  let crowdfunding_class_hash = declare_crowdfunding_contract();
  let (crowdfunding_factory, _) = deploy_crowdfunding_factory(crowdfunding_class_hash);

  assert_eq!(crowdfunding_factory.get_crowdfunding_class_hash(), crowdfunding_class_hash);
}

#[test]
fn it_should_create_crowdfunding() {
  let crowdfunding_class_hash = declare_crowdfunding_contract();
  let (crowdfunding_factory, _) = deploy_crowdfunding_factory(crowdfunding_class_hash);

  let manager = ADDRESSES::CALLER.get();
  let minimum_contribution = 10;

  let crowdfunding_address = crowdfunding_factory.create_crowdfunding(manager, minimum_contribution);

  assert_eq!(crowdfunding_factory.get_crowdfunding_class_hash(), crowdfunding_class_hash);
  
  let crowdfunding_dispatcher = get_crowdfunding_dispatcher(crowdfunding_address);
  assert_eq!(crowdfunding_dispatcher.get_manager(), manager);
  assert_eq!(crowdfunding_dispatcher.get_minimum_contribution(), minimum_contribution);
}

#[test]
fn it_should_update_crowdfunding_class_hash() {
  let crowdfunding_class_hash = declare_crowdfunding_contract();
  let (crowdfunding_factory, _) = deploy_crowdfunding_factory(crowdfunding_class_hash);

  assert_eq!(crowdfunding_factory.get_crowdfunding_class_hash(), crowdfunding_class_hash);
  let new_class_hash = declare_crowdfunding_contract();
  crowdfunding_factory.update_crowdfunding_class_hash(new_class_hash);

  assert_eq!(crowdfunding_factory.get_crowdfunding_class_hash(), new_class_hash);
}

#[test]
fn it_should_get_crowdfundings() {
  let crowdfunding_class_hash = declare_crowdfunding_contract();
  let (crowdfunding_factory, _) = deploy_crowdfunding_factory(crowdfunding_class_hash);

  let caller = ADDRESSES::CALLER.get();
  let minimum_contribution = 10;

  let crowdfunding1 = crowdfunding_factory.create_crowdfunding(caller, minimum_contribution);
  let crowdfunding2 = crowdfunding_factory.create_crowdfunding(caller, minimum_contribution);

  let crowdfundings = crowdfunding_factory.get_crowdfundings();

  assert_eq!(crowdfundings.len(), 2);

  let mut is_crowdfunding1_contained_in_crowdfundings = false;
  let mut is_crowdfunding2_contained_in_crowdfundings = false;
  let mut number_of_crowdfundings = 2;
  for address in crowdfundings {
    if address == crowdfunding1 {
      is_crowdfunding1_contained_in_crowdfundings = true;
      number_of_crowdfundings -= 1;
    } else if address == crowdfunding2 {
      is_crowdfunding2_contained_in_crowdfundings = true;
      number_of_crowdfundings -= 1;
    } else if number_of_crowdfundings == 0 {
      break;
    }
  };

  assert!(is_crowdfunding1_contained_in_crowdfundings, "crowdfunding1 should be in the list of crowdfundings");
  assert!(is_crowdfunding2_contained_in_crowdfundings, "crowdfunding2 should be in the list of crowdfundings");
}