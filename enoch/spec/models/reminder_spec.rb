# == Schema Information
#
# Table name: reminders
#
#  id                      :integer         not null, primary key
#  sender                  :integer
#  recipient               :integer
#  subject                 :string(255)
#  body                    :text
#  is_read                 :boolean         default(FALSE)
#  is_deleted_by_sender    :boolean         default(FALSE)
#  is_deleted_by_recipient :boolean         default(FALSE)
#  created_at              :datetime
#  updated_at              :datetime
#

require 'spec_helper'



describe Reminder do
before(:each) do
    @reminder_attr = {
      :body => "sunil",
    }
  end
  describe "validation" do
    it "reminder should exist" do
      reminder = Reminder.new(@reminder_attr)
      reminder.should be_valid
    end
    it "should response to body" do
      reminder = Reminder.new(@reminder_attr)
      reminder.should respond_to(:body)
    end
    it "body should presence" do
      reminder = Reminder.new(@reminder_attr.merge(:body => ""))
      reminder.should_not be_valid
    end
    it "should belongs to user" do
      reminder = Reminder.new(@reminder_attr)
      reminder.should respond_to(:user)
    end
    it "should belongs to to_user" do
      reminder = Reminder.new(@reminder_attr)
      reminder.should respond_to(:to_user)
    end
    it "should response to per_page" do
      reminder = Reminder.new(@reminder_attr)
      reminder.should respond_to(:per_page)
    end

  end
end
