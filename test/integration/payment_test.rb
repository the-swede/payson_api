# encoding: utf-8

require 'test/unit'
require 'test_helper'
require 'payson_api'

class PaymentTest < Test::Unit::TestCase
  include TestHelper

  def test_generated_hash_from_payment_data
    setup_payment_hash(include_order_items = true)

    assert_equal PAYMENT_DATA[:return_url], @payment_hash['returnUrl']
    assert_equal PAYMENT_DATA[:cancel_url], @payment_hash['cancelUrl']
    assert_equal PAYMENT_DATA[:ipn_url], @payment_hash['ipnNotificationUrl']
    assert_equal PAYMENT_DATA[:memo], @payment_hash['memo']

    # Ensure expected format of receiver list
    receiver_format = PaysonAPI::Receiver::FORMAT_STRING
    @receivers.each_with_index do |receiver, index|
      email = @payment_hash[receiver_format % [index, 'email']]
      amount = @payment_hash[receiver_format % [index, 'amount']]

      assert_equal receiver.email, email
      assert_equal receiver.amount, amount
    end

    # Do same test for order items
    order_item_format = PaysonAPI::OrderItem::FORMAT_STRING
    @order_items.each_with_index do |order_item, index|
      description = @payment_hash[order_item_format % [index, 'description']]
      unit_price = @payment_hash[order_item_format % [index, 'unitPrice']]
      quantity = @payment_hash[order_item_format % [index, 'quantity']]
      tax = @payment_hash[order_item_format % [index, 'taxPercentage']]
      sku = @payment_hash[order_item_format % [index, 'sku']]

      assert_equal order_item.description, description
      assert_equal order_item.unit_price, unit_price
      assert_equal order_item.quantity, quantity
      assert_equal order_item.tax, tax
      assert_equal order_item.sku, sku
    end
  end

  def test_payment_initiation_request
    token = acquire_token

    if !token
      puts "Token was not received, please look into your test config"
      return
    end
  end
end