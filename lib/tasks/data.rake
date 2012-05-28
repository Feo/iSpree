namespace :spree do
	desc "Load deals' data into the system"
	task :product_load => :environment do
		deals = Deal.all
		deals.each do |deal|
			puts Spree::Product.create :name => deal.intro[0..19], :price => deal.price, :description => deal.intro, :available_on => "2012-05-23 00:00:00"
		end
  end

	desc "Test image data"
	task :image_test => :environment do
		deals = Deal.all
		deals.each do |deal|
			image = deal.image.gsub(/.*\//, "")
			puts Spree::Asset.create attachment_width: 440, attachment_height: 280, attachment_file_size: 68679, position: 1, viewable_type: "Spree::Variant", attachment_content_type: "image/jpeg", attachment_file_name: image, type: "Spree::Image", attachment_updated_at: "2012-05-25 08:18:48", alt: ""
		end
	end

	desc "save images from urls"
	task :image_save => :environment do
		deals = Deal.all
		deals.each do |deal|
			if deal.image != "http://d1.lashouimg.com/zt/201205/11/133673243522064000.jpg"
				resp = Net::HTTP.get(URI(deal.image))
				image = deal.image.gsub(/.*\//, "")
				puts path = "/home/expedia/projects/iSpree/tmp/image/#{image}" 
				open( path, 'wb' ) do |file|
		  		file.write(resp)
				end
			end
		end
  end

  desc "Load image data into the system"
	task :image_load => :environment do
		FileUtils.mkdir_p "#{Rails.root}/public/spree/products/"

		Spree::Asset.all.each do |asset|
			filename = asset.attachment_file_name
			puts "-- Processing image: #{filename}\r"
			path = File.join(File.dirname(__FILE__), "../../tmp/image/#{filename}")

			if FileTest.exists? path
				asset.attachment = File.open(path)
				asset.save
			else
				puts "--- Could not find image at: #{path}"
			end
		end
  end
end
