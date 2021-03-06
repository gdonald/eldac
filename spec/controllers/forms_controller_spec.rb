# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormsController, type: :controller do
  describe 'POST #save_sort' do
    let(:user) { create(:user, :valid_user) }
    let(:project) { create(:project) }
    let(:relationship) { create(:relationship, :owner) }
    let!(:user_project) { create(:user_project, user: user, project: project, relationship: relationship) }
    let(:form) { create(:form, project: project) }
    let(:form2) { create(:form, project: project, name: 'Form 2') }
    let(:order) { "f[]=#{form.id}&f[]=#{form2.id}" }

    it 'anon user returns redirect' do
      post :save_sort, params: { project_id: project.id, order: order }, session: { user_id: nil }
      expect(response).to have_http_status(:redirect)
    end

    it 'invalid project returns redirect' do
      post :save_sort, params: { project_id: 0, order: order }, session: { user_id: user.id }
      expect(response).to have_http_status(:redirect)
    end

    it 'valid project and order sorts' do
      post :save_sort, params: { project_id: project.id, order: order }, session: { user_id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user, :valid_user) }
    let(:project) { create(:project) }
    let(:relationship) { create(:relationship, :owner) }
    let!(:user_project) { create(:user_project, user: user, project: project, relationship: relationship) }

    it 'anon user returns redirect' do
      expect do
        post :create, params: { project_id: project.id, form: { name: 'Form 1' } }, session: { user_id: nil }
      end.to change(Form, :count).by(0)
      expect(response).to have_http_status(:redirect)
    end

    it 'valid form returns redirect' do
      expect do
        post :create, params: { project_id: project.id, form: { name: 'Form 1' } }, session: { user_id: user.id }
      end.to change(Form, :count).by(1)
      expect(response).to have_http_status(:redirect)
    end

    it 'invalid form returns errors' do
      expect do
        post :create, params: { project_id: project.id, form: { name: nil } }, session: { user_id: user.id }
      end.to change(Form, :count).by(0)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user, :valid_user) }
    let(:project) { create(:project) }
    let(:relationship) { create(:relationship, :owner) }
    let!(:user_project) { create(:user_project, user: user, project: project, relationship: relationship) }
    let(:form) { create(:form, project: project) }

    it 'anon user returns redirect' do
      get :edit, params: { project_id: project.id, id: form.id }, session: { user_id: nil }
      expect(response).to have_http_status(:redirect)
    end

    it 'invalid project id returns redirect' do
      get :edit, params: { project_id: 0, id: form.id }, session: { user_id: user.id }
      expect(response).to have_http_status(:redirect)
    end

    it 'invalid form id returns redirect' do
      get :edit, params: { project_id: project.id, id: 0 }, session: { user_id: user.id }
      expect(response).to have_http_status(:redirect)
    end

    it 'returns http success' do
      get :edit, params: { project_id: project.id, id: form.id }, session: { user_id: user.id }
      expect(response).to render_template('forms/edit')
    end
  end

  describe 'POST #update' do
    let(:user) { create(:user, :valid_user) }
    let(:project) { create(:project) }
    let(:relationship) { create(:relationship, :owner) }
    let!(:user_project) { create(:user_project, user: user, project: project, relationship: relationship) }
    let(:form) { create(:form, project: project) }

    it 'anon user returns redirect' do
      post :update, params: { project_id: project.id, id: form.id, form: { name: 'New' } }, session: { user_id: nil }
      expect(response).to have_http_status(:redirect)
    end

    it 'valid form returns redirect' do
      post :update, params: { project_id: project.id, id: form.id, form: { name: 'New' } }, session: { user_id: user.id }
      expect(response).to have_http_status(:redirect)
    end

    it 'invalid form returns errors' do
      post :update, params: { project_id: project.id, id: form.id, form: { name: nil } }, session: { user_id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #ask_delete' do
    let(:user) { create(:user, :valid_user) }
    let(:project) { create(:project) }
    let(:relationship) { create(:relationship, :owner) }
    let!(:user_project) { create(:user_project, user: user, project: project, relationship: relationship) }
    let(:form) { create(:form, project: project) }

    it 'anon user returns redirect' do
      get :ask_delete, xhr: true, params: { project_id: project.id, id: form.id }, session: { user_id: nil }
      expect(response).to have_http_status(:redirect)
    end

    it 'invalid project id returns redirect' do
      get :ask_delete, xhr: true, params: { project_id: 0, id: form.id }, session: { user_id: user.id }
      expect(response).to have_http_status(:redirect)
    end

    it 'invalid form id returns redirect' do
      get :ask_delete, xhr: true, params: { project_id: project.id, id: 0 }, session: { user_id: user.id }
      expect(response).to have_http_status(:redirect)
    end

    it 'returns http success' do
      get :ask_delete, xhr: true, params: { project_id: project.id, id: form.id }, session: { user_id: user.id }
      expect(response).to render_template('forms/ask_delete')
    end
  end

  describe 'POST #destroy' do
    let(:user) { create(:user, :valid_user) }
    let(:project) { create(:project) }
    let(:relationship) { create(:relationship, :owner) }
    let!(:user_project) { create(:user_project, user: user, project: project, relationship: relationship) }
    let!(:form) { create(:form, project: project) }

    it 'returns redirect' do
      expect do
        delete :destroy, params: { project_id: project.id, id: form.id, format: :js }, session: { user_id: user.id }
      end.to change(Form, :count).by(-1)
      expect(response).to render_template('forms/destroy')
    end

    it 'anon user returns redirect' do
      expect do
        delete :destroy, params: { project_id: project.id, id: form.id, format: :js }, session: { user_id: nil }
      end.to change(Form, :count).by(0)
      expect(response).to have_http_status(:redirect)
    end

    it 'invalid form returns redirect' do
      expect do
        delete :destroy, params: { project_id: project.id, id: 0, format: :js }, session: { user_id: user.id }
      end.to change(Form, :count).by(0)
      expect(response).to have_http_status(:redirect)
    end

    it 'invalid form returns redirect' do
      expect do
        delete :destroy, params: { project_id: 0, id: form.id, format: :js }, session: { user_id: user.id }
      end.to change(Form, :count).by(0)
      expect(response).to have_http_status(:redirect)
    end
  end
end
