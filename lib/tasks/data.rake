namespace :spree do
	desc "Load deals' data into the system"
	task :load => :environment do
		deals = Deal.all
		deals.each do |deal|
			puts Spree::Product.create :name => deal.intro[0..19], :price => deal.price, :description => deal.intro, :available_on => "2012-05-23 00:00:00"
		end
  end

	desc "save images from urls"
	task :save_image => :environment do
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
	task :image => :environment do
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
