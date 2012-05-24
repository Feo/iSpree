namespace :spree do
	desc "Load deals' data into the system"
	task :load => :environment do
		deals = Deal.all
		deals.each do |deal|
			puts Spree::Product.create :name => deal.intro[0..19], :price => deal.price, :description => deal.intro, :available_on => "2012-05-23 00:00:00"
		end
  end
end
