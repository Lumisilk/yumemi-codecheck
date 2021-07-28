# 株式会社ゆめみ iOS エンジニアコードチェック課題

## 概要

本プロジェクトは株式会社ゆめみが出す課題の結果プロジェクトです。

ベースプロジェクトにあった課題の中に、「新機能を追加」以外は全部取り組んだと思います。

最終的にこの様に動作をしています：

https://user-images.githubusercontent.com/11924267/127363983-3f278279-87c1-45a8-87bd-bfb1e5261675.mp4

## 環境

- Xcode 12.5.1
- Swift 5.4.2
- 開発ターゲット：iOS 14.1
- サードパーティーライブラリーの利用：Kingfisher, Snapkit, SwiftLint

## ハイライト

- No storyboard
- UI ブラッシュアップ
- 通信部分を切り分け
- 通信部分のテスト
- UIKit / SwiftUI 両方使用
- Combine による MVVM アーキテクチャの採用
- ViewModel のテスト

## プロジェクト構成と紹介

- Entity

  API のレスポンスを表す構造体

- Network

  通信部分
  - `Request` リクエストのプロトコル。一つのリクエストが `Request` に準拠する。
  - `Client` のプロトコルとその実現 `GithubClient`、リクエストの発送を担当する。
  - `RepositorySearchRequest` レポジトリを検索するリクエと `RepositoryRequest` レポジトリ自体のリクエ
    （前者にレポジトリの Watcher 数が含んでいないため、後者でレポジトリ詳細をリクエスト必要がある）
    
- Utility
    
    開発に補助するもの
    
- PreviewData: 

    SwiftUI の Preview を使うため入れたダミーデータ
    
- View
  
  レポジトリ検索とレポジトリ詳細がある。UIKit と SwiftUI を合わせるため、`ViewModel` の実現が少し違う。

- Test

  通信と ViewModel の動作テストを入れた。UITest なし。