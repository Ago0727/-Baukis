class StaffMemberPresenter < ModelPresenter
  delegate :suspended?, to: :object
  def full_name
    object.family_name + " " + object.given_name
  end

  def full_name_kana
    object.family_name_kana + " " + object.given_name_kana
  end
  def suspended_mark
    suspended? ? view_context.raw('&#x2611;') :
        view_context.raw('&#x2610;')
  end
end