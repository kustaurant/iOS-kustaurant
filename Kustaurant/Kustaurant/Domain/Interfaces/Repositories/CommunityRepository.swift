//
//  CommunityRepository.swift
//  Kustaurant
//
//  Created by 송우진 on 10/13/24.
//

import Foundation

protocol CommunityRepository {
    func getPosts(category: CommunityPostCategory, page: Int, sort: CommunityPostSortType) async -> Result<[CommunityPostDTO], NetworkError>
    func getPostDetail(postId: Int) async -> Result<CommunityPostDTO, NetworkError>
    func postCommunityPostLikeToggle(postId: Int) async -> Result<CommunityLikeStatus, NetworkError>
    func postCommunityPostScrapToggle(postId: Int) async -> Result<CommunityScrapStatus, NetworkError>
    func postCommunityCommentLikeToggle(commentId: Int, action: CommentActionType) async -> Result<CommunityCommentStatus, NetworkError>
    func deleteCommunityComment(commentId: Int) async -> Result<Void, NetworkError>
    func createPost(title: String, postCategory: String, content: String, imageFile: String?) async -> Result<CommunityPostDTO, NetworkError>
    func uploadImage(imageData: Data?) async -> Result<UploadImageResponse, NetworkError>
    func deletePost(postId: Int) async -> Result<Void, NetworkError>
    func writeComment(postId: String, parentCommentId: String?, content: String) async -> Result<CommunityPostDTO.PostComment, NetworkError>
}
