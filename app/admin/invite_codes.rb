ActiveAdmin.register InviteCode do
  menu label: "Invites"

  action_item { link_to "Generate Invite Codes", generate_admin_invite_codes_path }
  collection_action :generate do
    10.times {|i| InviteCode.create}

    redirect_to action: :index, notice: "created 10 codes"
  end


  batch_action :issue do |selection|
    InviteCode.find(selection).each do |code|
      code.issue
    end
    redirect_to action: :index, notice: "issued #{selection.count}"
  end
end
