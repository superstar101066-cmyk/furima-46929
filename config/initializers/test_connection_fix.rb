if Rails.env.test?
  ActiveSupport.on_load(:active_record) do
    # Rails 7.1の自動クエリ並列化を無効化し、接続をメインスレッドに固定する
    self.active_record_shard_resolver = nil if respond_to?(:active_record_shard_resolver=)
  end

  # データベース接続の「チェックアウト（貸し出し）」時のバリデーションを無効にする
  # これにより、workerスレッドが接続を横取りしようとするのを防ぐ
  class ActiveRecord::ConnectionAdapters::AbstractAdapter
    def active?
      true
    end
  end
end