require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    before do
      @user = FactoryBot.build(:user)
    end

    it 'nickname, email, password, password_confirmation, family_name, first_name, family_name_kana, first_name_kana, birth_dateが存在すれば登録できること' do
      expect(@user).to be_valid
    end

    it 'nicknameが空では登録できないこと' do
      @user.nickname = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Nickname can't be blank")
    end

    it 'emailが空では登録できないこと' do
      @user.email = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end

    it 'emailが重複して存在している場合は登録できないこと' do
      @user.save
      another_user = FactoryBot.build(:user, email: @user.email)
      another_user.valid?
      expect(another_user.errors.full_messages).to include("Email has already been taken")
    end

    it 'emailに＠が含まれていないと登録できないこと' do
      @user.email = 'test.co.jp'
      @user.valid?
      expect(@user.errors.full_messages).to include("Email is invalid")
    end

    it 'passwordが空では登録できないこと' do
      @user.password = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end

    it 'passwordが６文字以上かつ半角英数字混合だと登録できること' do
      @user.password = 'test12'
      @user.password_confirmation = 'test12'
      expect(@user).to be_valid
    end

    it 'passwordが６文字未満では登録できないこと' do
      @user.password = '12345'
      @user.password_confirmation = '12345'
      @user.valid?
      expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
    end

    it 'passwordが半角英数字混合でないと登録できないこと' do
      @user.password = '123456'
      @user.password_confirmation = '123456'
      @user.valid?
      expect(@user.errors.full_messages).to include("Password Include both letters and numbers")
    end

    it 'passwordとpassword_confirmationが不一致では登録できないこと' do
      @user.password = 'test55'
      @user.password_confirmation = 'test33'
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'family_nameが全角（漢字・ひらがな・カタカナ）でないと登録できないこと' do
      @user.family_name = 'test'
      @user.valid?
      expect(@user.errors.full_messages).to include("Family name Full-width characters")
    end

    it 'first_nameが全角（漢字・ひらがな・カタカナ）でないと登録できないこと' do
      @user.first_name = 'test'
      @user.valid?
      expect(@user.errors.full_messages).to include("First name Full-width characters")
    end

    it 'family_name_kanaが全角（カタカナ）でないと登録できないこと' do
      @user.family_name_kana = 'ｶﾀｶﾅ'
      @user.valid?
      expect(@user.errors.full_messages).to include("Family name kana Full-width katakana characters")
    end

    it 'first_name_kanaが全角（カタカナ）でないと登録できないこと' do
      @user.first_name_kana ='ｶﾀｶﾅ'
      @user.valid?
      expect(@user.errors.full_messages).to include("First name kana Full-width katakana characters")
    end
  end
end
