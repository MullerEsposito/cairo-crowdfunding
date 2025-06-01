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