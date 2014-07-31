# -*- coding: utf-8 -*-

require 'test_helper'

class BankTest < ActiveSupport::TestCase
  fixtures :banks

  test '正しい値を保存できること' do
    b = Bank.new(zengin_code: '9999', name: 'ほげ銀行', name_kana: 'ﾎｹﾞｷﾞﾝｺｳ')
    assert(b.valid?)
  end

  test '不正な銀行名を保存できないこと' do
    b = Bank.new(zengin_code: '0100', name: 'あ' * 255, name_kana: 'ﾅｶﾞｽｷﾞｷﾞﾝｺｳ')
    assert(! b.valid?)
    assert(b.errors[:name].any?)

    b = Bank.new(zengin_code: '0101', name: '', name_kana: 'ｶﾗﾓｼﾞｷﾞﾝｺｳ')
    assert(! b.valid?)
    assert(b.errors[:name].any?)
  end

  test '不正な銀行名カナを保存できないこと' do
    b = Bank.new(zengin_code: '0200', name: '長すぎ銀行', name_kana: 'ｱ' * 255)
    assert(! b.valid?)
    assert(b.errors[:name_kana].any?)

    b = Bank.new(zengin_code: '0201', name: '空文字銀行', name_kana: '')
    assert(! b.valid?)
    assert(b.errors[:name_kana].any?)
  end

  test '不正な金融機関コードを保存できないこと' do
    b = Bank.new(zengin_code: '10000', name: '一銀行', name_kana: 'ｲﾁｷﾞﾝｺｳ')
    assert(! b.valid?)
    assert(b.errors[:zengin_code].any?)

    b = Bank.new(zengin_code: 'あ', name: 'あ銀行', name_kana: 'ｱｷﾞﾝｺｳ')
    assert(! b.valid?)
    assert(b.errors[:zengin_code].any?)

    b = Bank.new(zengin_code: '', name: 'なし銀行', name_kana: 'ﾅｼｷﾞﾝｺｳ')
    assert(! b.valid?)
    assert(b.errors[:zengin_code].any?)
  end
end
