require "csv"

class PagesController < ApplicationController
  protect_from_forgery with: :null_session, only: [:create_lead, :destroy_lead]

  before_action :authenticate_admin!, only: [:admin, :destroy_lead]

  def home
    @lead = Lead.new
  end

  def create_lead
    @lead = Lead.new(lead_params)
    if @lead.save
      redirect_to root_path, status: :see_other
    else
      render :home, status: :unprocessable_entity
    end
  end

  def admin
    @leads = Lead.order(created_at: :desc)

    respond_to do |format|
      format.html
      format.csv do
        send_data generate_csv(@leads),
                  filename: "leads-kreatix-#{Date.today}.csv",
                  type: "text/csv; charset=utf-8"
      end
    end
  end

  def destroy_lead
    @lead = Lead.find(params[:id])
    @lead.destroy
    redirect_to admin_path, status: :see_other
  end

 def login
    if request.post?
      if params[:username] == "admin" && params[:password] == "admin123"
        session[:admin_logged_in] = true
        redirect_to "/admin" and return
      else
        redirect_to "/login" and return
      end
    end
  end

  def logout
    session[:admin_logged_in] = nil
    redirect_to root_path, status: :see_other, notice: "Déconnecté !"
  end

  private


  def authenticate_admin!
    unless session[:admin_logged_in]
      redirect_to "/login" and return
    end
  end

  def generate_csv(leads)
    CSV.generate(headers: true) do |csv|
      csv << ["ID", "Date", "Nom", "Email", "Telephone", "Choix / Services"]
      leads.each do |lead|
        csv << [
          lead.id,
          lead.created_at.strftime("%d/%m/%Y %H:%M"),
          lead.name,
          lead.email,
          lead.phone,
          lead.choices
        ]
      end
    end
  end

  def lead_params
    params.require(:lead).permit(:name, :email, :phone, :choices)
  end
end