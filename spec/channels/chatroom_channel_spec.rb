require 'rails_helper'

RSpec.describe ChatroomChannel, type: :channel do
  let(:user) { create(:user) }
  let(:booking) { create(:booking) }
  let(:chatroom) { create(:chatroom, booking: booking) }

  before do
    # Connect to the channel with the user
    stub_connection(current_user_id: user.id)
  end

  it 'successfully subscribes to the chatroom when the user is associated' do
    # Simulate a subscription request with the chatroom's id
    subscribe(id: chatroom.id)

    # Expect the channel to have successfully subscribed
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_for(chatroom)
  end

  it 'rejects the subscription when the user is not associated' do
    # Create another user who is not associated with the chatroom
    another_user = create(:user)
    # Connect to the channel with the other user
    stub_connection(current_user_id: another_user.id)

    # Simulate a subscription request with the chatroom's id
    subscribe(id: chatroom.id)

    # Expect the channel to reject the subscription
    expect(subscription).to be_rejected
  end
end