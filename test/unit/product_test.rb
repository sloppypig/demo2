require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes should not be empty " do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?


  end

  test "product price must be positive" do
    product = Product.new(:title => "My Book Title",
                          :description => "yyy", :image_url => "zzz.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
                 product.errors[:price].join('; ')
    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
                 product.errors[:price].join('; ')
    product.price = 1
    assert product.valid?
  end

  test "image url in right format" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
               http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    ok.each do |good_image|
      assert new_product(good_image).valid?, "#good_image shouldn't be invalid'"
    end
    bad.each do |bad_image|
      assert new_product(bad_image).invalid?, "#bad_image shouldn't be valid'"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(:title => products(:ruby).title,
                          :description => "yy",
                          :price => 1,
                          :image_url => "fred.gif")
    assert !product.save
    assert_match(%r{already been taken}, product.errors[:title].join('; '))
    assert_equal I18n.translate('activerecord.errors.messages.taken'),
    product.errors[:title].join('; ')

  end

  def new_product(image_url)
    Product.new(:title => "some title",
                :description => "some description",
                :image_url => image_url,
                :price => 25)
  end
end
