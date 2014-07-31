# -*- coding: utf-8 -*-

require 'test_helper'

class BankBranchTest < ActiveSupport::TestCase
  fixtures :banks
  fixtures :bank_branches

  test '正しい値を保存できること' do
    b = BankBranch.new(bank_id: 1, zengin_code: '010', name: 'ほげ', name_kana: 'ﾎｹﾞ', show_order: 1)
    assert(b.valid?)
  end

  test '不正な支店名を保存できないこと' do
    b = BankBranch.new(bank_id: 1, zengin_code: '0100', name: 'あ' * 255, name_kana: 'ﾅｶﾞｽｷﾞ', show_order: 1)
    assert(! b.valid?)
    assert(b.errors[:name].any?)

    b = BankBranch.new(bank_id: 1, zengin_code: '0101', name: '', name_kana: 'ｶﾗﾓｼﾞ', show_order: 1)
    assert(! b.valid?)
    assert(b.errors[:name].any?)
  end

  test '不正な支店名カナを保存できないこと' do
    b = BankBranch.new(bank_id: 1, zengin_code: '0200', name: '長すぎ', name_kana: 'ｱ' * 255, show_order: 1)
    assert(! b.valid?)
    assert(b.errors[:name_kana].any?)

    b = BankBranch.new(bank_id: 1, zengin_code: '0201', name: '空文字', name_kana: '', show_order: 1)
    assert(! b.valid?)
    assert(b.errors[:name_kana].any?)
  end

  test '不正な金融機関コードを保存できないこと' do
    b = BankBranch.new(bank_id: 1, zengin_code: '1000', name: 'オーバー', name_kana: 'ｵｰﾊﾟｰ', show_order: 1)
    assert(! b.valid?)
    assert(b.errors[:zengin_code].any?)

    b = BankBranch.new(bank_id: 1, zengin_code: '0', name: 'ゼロ', name_kana: 'ｾﾞﾛ', show_order: 1)
    assert(! b.valid?)
    assert(b.errors[:zengin_code].any?)

    b = BankBranch.new(bank_id: 1, zengin_code: '', name: '空', name_kana: 'ｶﾗ', show_order: 1)
    assert(! b.valid?)
    assert(b.errors[:zengin_code].any?)
  end

  test '不正な金融機関IDを保存できないこと' do
    b = BankBranch.new(bank_id: nil, zengin_code: '100', name: '未指定', name_kana: 'ﾐｼﾃｲ', show_order: 1)
    assert(! b.valid?)
    assert(b.errors[:bank_id].any?)

    b = BankBranch.new(bank_id: 0, zengin_code: '100', name: 'ゼロ', name_kana: 'ｾﾞﾛ', show_order: 1)
    assert(! b.valid?)
    assert(b.errors[:bank_id].any?)
  end
end
