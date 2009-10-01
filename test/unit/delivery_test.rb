require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class DeliveryTest < ActiveSupport::TestCase
  should_belong_to :entry, :user, :channel

  # should "not deliver to subscriptions for missing regions"
  # should "not deliver to inactive regions"

  
  context "Delivery system" do
    context "for news messages" do      
      setup do
        time = Time.zone.parse("12:00")
        Time.stubs(:now).returns(time)
        @user = Factory(:user_with_number)
        @channel = Factory(:channel)
        @feed = Factory(:feed, :channel => @channel)
        @entry = Factory(:entry, :feed => @feed, :message => 'Viva los monkeys!')
        @subscription = Factory(:subscription, :channel => @channel, :user => @user)
      end

      should "deliver messages to subscriptions for users and channels" do
        should_send_message_to @user.number, /Viva los monkeys/ do
          should_deliver_entry @entry.id do
            Delivery.deliver_to(@subscription)
          end  
        end  
      end
      
      should "not deliver to subscriptions for missing users" do
        should_not_deliver_entry @entry.id do
          @user.destroy
          @subscription.reload
          Delivery.deliver_to(@subscription)
        end  
      end
      
      should "not deliver to subscriptions for missing channels" do
        should_not_deliver_entry @entry.id do
          @channel.destroy
          @subscription.reload
          Delivery.deliver_to(@subscription)
        end  
      end
      
      should "not deliver to subscriptions for inactive users" do
        should_not_deliver_entry @entry.id do
          @user.deactivate
          Delivery.deliver_to(@subscription)
        end  
      end
      
      should "not deliver to unconfirmed users" do
        should_not_deliver_entry @entry.id do
          @user.update_attributes(:number_confirmed => false)
          Delivery.deliver_to(@subscription)
        end  
      end
      
      should "not deliver to subscriptions for inactive channels" do
        should_not_deliver_entry @entry.id do
          @channel.deactivate
          Delivery.deliver_to(@subscription)
        end  
      end
            
      should "not deliver during a users quiet hours" do
        should_not_deliver_entry @entry.id do
          time = Time.zone.parse("3:00")
          Time.stubs(:now).returns(time)
          Delivery.deliver_to(@subscription)
        end  
      end
      
      should "deliver messages for subscriptions that need more deliveries" do
        should_send_message_to @user.number, /Viva los monkeys/ do
          @subscription.number_per_day = 1
          @subscription.save!
          assert_equal 0, Delivery.delivery_count(@subscription)
          should_deliver_entry @entry.id do
            Delivery.deliver_to(@subscription)
          end  
          assert_equal 1, Delivery.delivery_count(@subscription)
        end  
      end
      
      should "not deliver messages for subscriptions that have had the alotted messages" do
        @subscription.number_per_day = 1
        @subscription.save!
        Delivery.deliver_to(@subscription)
        assert_equal 1, Delivery.delivery_count(@subscription)
        # Later that day...
        time = Time.zone.parse("14:00")
        Time.stubs(:now).returns(time)        
        @entry = Factory(:entry, :feed => @feed, :message => 'Muertos los monkeys!')
        should_not_deliver_entry @entry.id do
          Delivery.deliver_to(@subscription)
        end  
      end
        
      should "not deliver the same message twice" do
        Delivery.deliver_to(@subscription)
        assert_equal 1, Delivery.delivery_count(@subscription)
        # Later that day...
        time = Time.zone.parse("14:00")
        Time.stubs(:now).returns(time)        
        Delivery.deliver_to(@subscription)
        assert_equal 1, Delivery.delivery_count(@subscription)
      end

      should "not deliver messages if a message was delivered to this subscription recently" do
        Delivery.deliver_to(@subscription)
        # Ten minutes later...
        time = Time.zone.parse("12:10")
        Time.stubs(:now).returns(time)        
        @entry = Factory(:entry, :feed => @feed, :message => 'Muertos los monkeys!')
        should_not_deliver_entry @entry.id do
          Delivery.deliver_to(@subscription)
        end  
      end
      
      should "not deliver messages if a message was delivered to another subscription recently" do
        Delivery.deliver_to(@subscription)
        # Ten minutes later...
        time = Time.zone.parse("12:10")
        Time.stubs(:now).returns(time)        
        @channel = Factory(:channel)
        @feed = Factory(:feed, :channel => @channel)
        @entry = Factory(:entry, :feed => @feed, :message => 'Muertos los monkeys!')
        @subscription = Factory(:subscription, :channel => @channel, :user => @user)
        should_not_deliver_entry @entry.id do
          Delivery.deliver_to(@subscription)
        end  
      end
      
      should "not deliver messages if a message was delivered to a system channel recently" do
        Delivery.deliver_to(@subscription)
        # One minute later...
        time = Time.zone.parse("12:01")
        Time.stubs(:now).returns(time)        
        @channel = Factory(:channel)
        @feed = Factory(:feed, :channel => @channel)
        @entry = Factory(:entry, :feed => @feed, :message => 'Muertos los monkeys!')
        @subscription = Factory(:subscription, :channel => @channel, :user => @user)
        should_not_deliver_entry @entry.id do
          Delivery.deliver_to(@subscription)
        end  
      end
            
      should "deliver messages if it has been longer than the users delay since the last message" do
        Delivery.deliver_to(@subscription)
        # One hour later...
        time = Time.zone.parse("13:00")
        Time.stubs(:now).returns(time)        
        @entry = Factory(:entry, :feed => @feed, :message => 'Muertos los monkeys!')
        should_send_message_to @user.number, /Muertos los monkeys/ do
          should_deliver_entry @entry.id do
            Delivery.deliver_to(@subscription)
          end  
        end  
      end
      
      should "should not consider other users when calculating need or delay" do
        Delivery.deliver_to(@subscription)
        @user = Factory(:user_with_number)
        @subscription = Factory(:subscription, :channel => @channel, :user => @user)
        @subscription.number_per_day = 1
        @subscription.save!
        should_send_message_to @user.number, /Viva los monkeys/ do
          assert_equal 0, Delivery.delivery_count(@subscription)
          Delivery.deliver_to(@subscription)
          assert_equal 1, Delivery.delivery_count(@subscription)
        end  
      end
      
      should "only deliver one message at a time and it should be the most recent" do
        time = Time.zone.parse("12:01")
        Time.stubs(:now).returns(time)                
        @another_entry = Factory(:entry, :feed => @feed, :message => 'Muertos los monkeys!')
        should_deliver_entry @another_entry.id do
          should_not_deliver_entry @entry.id do
            Delivery.deliver_to(@subscription)
          end  
        end  
      end

      should "not deliver an entry if it is older than one they have already received" do
        time = Time.zone.parse("12:01")
        Time.stubs(:now).returns(time)                
        @another_entry = Factory(:entry, :feed => @feed, :message => 'Muertos los monkeys!')
        Delivery.deliver(@user.id, @channel.id, @another_entry, PRIORITY[:low])
        time = Time.zone.parse("14:00")
        Time.stubs(:now).returns(time)                
        should_not_deliver_entry @entry.id do
          Delivery.deliver_to(@subscription)
        end          
      end
            
      should "have low priority" do
        Delivery.deliver_to(@subscription)
        assert_equal PRIORITY[:low], Outbox.last.priority
      end
    end
    
    context "for popular messages" do
      setup do
        time = Time.zone.parse("12:00")
        Time.stubs(:now).returns(time)        
        @user = Factory(:user_with_number)
        @channel = Factory(:channel, :region => @user.gateway.region, :system => true)
        @feed = Factory(:feed, :channel => @channel)
        @entry = Factory(:entry, :feed => @feed, :message => 'Viva los monkeys!', :published_at => nil)
        @popular = Factory(:popular, :entry => @entry, :channel => @channel)
      end

      should "deliver to users" do
        should_send_message_to @user.number, /Viva los monkeys/ do
          should_deliver_entry @entry.id do
            Delivery.deliver_popular_messages_to(@user)
          end  
        end  
      end

      should "not deliver to inactive users" do
        should_not_deliver_entry @entry.id do
          @user.deactivate
          Delivery.deliver_popular_messages_to(@user)
        end  
      end
      
      should "not deliver to unconfirmed users" do
        should_not_deliver_entry @entry.id do
          @user.update_attributes(:number_confirmed => false)
          Delivery.deliver_popular_messages_to(@user)
        end  
      end
      
      should "not deliver messages that belong to other regions to users" do
        # Don't include the region here and it will be created
        @channel = Factory(:channel, :system => true, :emergency => true)
        @feed = Factory(:feed, :channel => @channel)
        @entry = Factory(:entry, :feed => @feed, :message => 'Viva los monkeys!', :published_at => nil)
        @popular = Factory(:popular, :entry => @entry, :channel => @channel)
        should_not_deliver_entry @entry.id do
          Delivery.deliver_popular_messages_to(@user)
        end  
      end

      should "not deliver during a users quiet hours" do
        should_not_deliver_entry @entry.id do
          time = Time.zone.parse("3:00")
          Time.stubs(:now).returns(time)
          Delivery.deliver_popular_messages_to(@user)
        end  
      end
    end    
    
    context "for system messages" do
      setup do
        time = Time.zone.parse("12:00")
        Time.stubs(:now).returns(time)        
        @user = Factory(:user_with_number)
        @channel = Factory(:channel, :region => @user.gateway.region, :system => true)
        @feed = Factory(:feed, :channel => @channel)
        @entry = Factory(:entry, :feed => @feed, :message => 'Viva los monkeys!', :published_at => nil)
      end

      should "deliver to users" do
        should_send_message_to @user.number, /Viva los monkeys/ do
          should_deliver_entry @entry.id do
            Delivery.deliver_system_messages_to(@user, @channel)
          end  
        end  
      end
      
      should "not deliver to inactive users" do
        should_not_deliver_entry @entry.id do
          @user.deactivate
          Delivery.deliver_system_messages_to(@user, @channel)
        end  
      end
      
      should "not deliver to unconfirmed users" do
        should_not_deliver_entry @entry.id do
          @user.update_attributes(:number_confirmed => false)
          Delivery.deliver_system_messages_to(@user, @channel)
        end  
      end
      
      should "not deliver for inactive channels" do
        should_not_deliver_entry @entry.id do
          @channel.deactivate
          Delivery.deliver_system_messages_to(@user, @channel)
        end  
      end
            
      should "not deliver messages for channels that belong to other regions" do
        # Don't include the region here and it will be created
        @channel = Factory(:channel, :system => true, :emergency => true)
        @feed = Factory(:feed, :channel => @channel)
        @entry = Factory(:entry, :feed => @feed, :message => 'Viva los monkeys!', :published_at => nil)
        should_not_deliver_entry @entry.id do
          Delivery.deliver_system_messages_to(@user, @channel)
        end  
      end

      should "not deliver during a users quiet hours" do
        should_not_deliver_entry @entry.id do
          time = Time.zone.parse("3:00")
          Time.stubs(:now).returns(time)
          Delivery.deliver_system_messages_to(@user, @channel)
        end  
      end
      
      should "deliver during a users quiet hours if it is an emergency" do
        should_send_message_to @user.number, /Viva los monkeys/ do
          time = Time.zone.parse("3:00")
          Time.stubs(:now).returns(time)
          @channel = Factory(:channel, :region => @user.gateway.region, :system => true, :emergency => true)
          @feed = Factory(:feed, :channel => @channel)
          @entry = Factory(:entry, :feed => @feed, :message => 'Viva los monkeys!', :published_at => nil)
          should_deliver_entry @entry.id do
            Delivery.deliver_system_messages_to(@user, @channel)
          end  
        end  
      end
      
      should "have normal priority if it is not an emergency" do
        Delivery.deliver_system_messages_to(@user, @channel)
        assert_equal PRIORITY[:normal], Outbox.last.priority
      end        

      should "have emergency priority if it is an emergency" do
        @channel = Factory(:channel, :region => @user.gateway.region, :system => true, :emergency => true)
        @feed = Factory(:feed, :channel => @channel)
        @entry = Factory(:entry, :feed => @feed, :message => 'Viva los monkeys!', :published_at => nil)
        Delivery.deliver_system_messages_to(@user, @channel)
        assert_equal PRIORITY[:emergency], Outbox.last.priority
      end        

      should "send more than one message" do
        @another_entry = Factory(:entry, :feed => @feed, :message => 'Muertos los monkeys!', :published_at => nil)
        should_deliver_entry @entry.id do
          should_deliver_entry @another_entry.id do
            Delivery.deliver_system_messages_to(@user, @channel)
          end
        end
      end

      should "not delay system messages" do
        Delivery.deliver_system_messages_to(@user, @channel)
        # One minute later...
        time = Time.zone.parse("12:01")
        Time.stubs(:now).returns(time)
        @another_entry = Factory(:entry, :feed => @feed, :message => 'Muertos los monkeys!', :published_at => nil)
        should_deliver_entry @another_entry.id do
          Delivery.deliver_system_messages_to(@user, @channel)
        end
      end
      
      should "not deliver entries that were created before the user joined" do
        # One minute later...
        time = Time.zone.parse("12:01")
        Time.stubs(:now).returns(time)
        @new_user = Factory(:user_with_number)
        should_not_deliver_entry @entry.id do
          Delivery.deliver_system_messages_to(@new_user, @channel)
        end        
      end
      
      should "not find entries that have a published date in the future" do
        @entry = Factory(:entry, :feed => @feed, :message => 'Viva los monkeys!', :published_at => Time.now + 1.day)
        should_not_deliver_entry @entry.id do
          Delivery.deliver_system_messages_to(@user, @channel)
        end        
      end
      
      should "find available entries that have been published in the past" do
        @entry = Factory(:entry, :feed => @feed, :message => 'Viva los monkeys!', :published_at => Time.now - 1.day)
        should_deliver_entry @entry.id do
          Delivery.deliver_system_messages_to(@user, @channel)
        end        
      end

      should "order messages so that the oldest ones are sent first" do
        @another_entry = Factory(:entry, :feed => @feed, :message => 'Muertos los monkeys!', :published_at => nil)
        should_deliver_entry @entry.id do
          should_deliver_entry @another_entry.id do
            Delivery.deliver_system_messages_to(@user, @channel)
          end
        end
        assert_equal @entry.id, Delivery.first.entry_id
        assert_equal @another_entry.id, Delivery.last.entry_id
      end
    end

    context "counting" do  
      setup do
        @time = Time.zone.parse("12:00")
        Time.stubs(:now).returns(@time)        
        @user = Factory(:user_with_number)
        @channel = Factory(:channel, :region => @user.gateway.region)
        @feed = Factory(:feed, :channel => @channel)
        @subscription = Factory(:subscription, :user => @user, :channel => @channel)
        @entry = Factory(:entry, :feed => @feed, :message => 'Viva los monkeys!', :published_at => nil)
        Delivery.deliver(@user.id, @channel.id, @entry, PRIORITY[:low])        
      end  

      should "include the delivery" do
        assert_equal 1, Delivery.send(:delivery_count, @subscription)
      end
      
      should "include multiple deliveries" do
        @another_entry = Factory(:entry, :feed => @feed, :message => 'Muertos los monkeys!')
        Delivery.deliver(@user.id, @channel.id, @another_entry, PRIORITY[:low])        
        assert_equal 2, Delivery.send(:delivery_count, @subscription)
      end
      
      should "not include deliveries from more than 24 hours ago" do
        Time.stubs(:now).returns(@time-25.hours)        
        @another_entry = Factory(:entry, :feed => @feed, :message => 'Muertos los monkeys!')
        Delivery.deliver(@user.id, @channel.id, @another_entry, PRIORITY[:low])        
        Time.stubs(:now).returns(@time)        
        assert_equal 1, Delivery.send(:delivery_count, @subscription)
      end   

      should "not include deliveries from other subscriptions" do
        @another_channel = Factory(:channel, :region => @user.gateway.region)
        @another_feed = Factory(:feed, :channel => @another_channel)
        @another_entry = Factory(:entry, :feed => @another_feed, :message => 'Muertos los monkeys!')
        Delivery.deliver(@user.id, @another_channel.id, @another_entry, PRIORITY[:low])        
        assert_equal 1, Delivery.send(:delivery_count, @subscription)
      end
      
      should "not include deliveries to other users" do
        @another_user = Factory(:user_with_number, :gateway => @user.gateway)
        Delivery.deliver(@another_user.id, @channel.id, @entry, PRIORITY[:low])        
        assert_equal 1, Delivery.send(:delivery_count, @subscription)
      end
      
      should "reset the number of deliveries each day in the timezone of the user" do
        # User lives at my house
        @user.update_attributes!(:timezone_offset => "-7") 
        # It is tomorrow UTC
        Time.stubs(:now).returns(@time+13.hours)        
        # I should still have one delivery today
        assert_equal 1, Delivery.send(:delivery_count, @subscription)
      end            
    end  
    
    context "ordering" do
      setup do
        @time = Time.zone.parse("12:00")
        Time.stubs(:now).returns(@time)        
        @user = Factory(:user_with_number)
        @channel = Factory(:channel, :region => @user.gateway.region)
        @feed = Factory(:feed, :channel => @channel)
        @subscription = Factory(:subscription, :user => @user, :channel => @channel)
        @entry = Factory(:entry, :feed => @feed, :message => 'Viva los monkeys!', :published_at => nil)
        @another_entry = Factory(:entry, :feed => @feed, :message => 'Muertos los monkeys!')
        Delivery.deliver(@user.id, @channel.id, @another_entry, PRIORITY[:low])        
      end  

      should "find the last delivered entry" do
        since = Delivery.last_delivered_entry_id(@subscription)        
        assert_equal @another_entry.id, since
        assert_not_equal Delivery.last.id, since
      end
    end
  end

  private
  
    def should_deliver_entry(entry_id, &block)        
      assert_nil Delivery.find_by_entry_id(entry_id)
      yield block
      assert_not_nil Delivery.find_by_entry_id(entry_id)      
    end
  
    def should_not_deliver_entry(entry_id, &block)        
      assert_nil Delivery.find_by_entry_id(entry_id)
      yield block
      assert_nil Delivery.find_by_entry_id(entry_id)      
    end
  
end
