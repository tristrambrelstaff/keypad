class Document < ApplicationRecord

  require "empty_where_fix"

  has_many :keys, dependent: :destroy

  def Document.ref_id_pairs
    Document.all.collect{|document|
      [document.ref, document.id]
    }.sort
  end

  def Document.searcher(params)
    joins = []
    conds = []
    vals = []
    unless params[:id].blank?
      conds << "documents.id = ?"
      vals << params[:id]
    end
    unless params[:ref].blank?
      conds << "documents.ref LIKE ?"
      vals << "%#{params[:ref]}%"
    end
    unless params[:citation].blank?
      conds << "documents.citation LIKE ?"
      vals << "%#{params[:citation]}%"
    end
    unless params[:language].blank?
      conds << "documents.language = ?"
      vals << params[:language]
    end
    OpenStruct.new(
      :joins => joins.uniq,
      :conds => empty_where_fix(conds),
      :vals => vals
    )
  end

end
